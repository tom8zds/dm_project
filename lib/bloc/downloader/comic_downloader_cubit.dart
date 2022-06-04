import 'dart:collection';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/comic/comic_local_model.dart';
import 'package:dmapicore/model/downloader/comic_download_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'comic_downloader_state.dart';

class ComicDownloaderCubit extends Cubit<ComicDownloaderState> {
  ComicDownloaderCubit() : super(ComicDownloaderState.initState());

  // 初始化 计算分块数量 初始化分块任务集合
  // 下载 从分块中下载
  // 停止 手动/出错 停止下载 cancel 正在下载的分块还在列队中
  // 完成 列队清空 合并分块 解压
  final Box missionBox = Hive.box(comicMissionBoxKey);
  final Box localComicBox = Hive.box(localComicBoxKey);

  final progress = ProgressImplementation();
  final downloaderMap = <String, DownloaderCore>{};

  Future toggleStatus() async {
    switch (state.status) {
      case ComicDownloaderStatus.start:
        await pauseAll();
        emit(state.copyWith(status: ComicDownloaderStatus.stop));
        return;
      case ComicDownloaderStatus.stop:
        handleNext();
        emit(state.copyWith(status: ComicDownloaderStatus.start));
        return;
    }
  }

  void loadMission() {
    emit(state.copyWith(missionQueue: missionBox.toMap().cast()));
  }

  Future removeMission(MissionInfo mission) async {
    if (downloaderMap.containsKey(mission.url)) {
      await downloaderMap[mission.url]!.cancel();
      downloaderMap.remove(mission.url);
    }
    File tmpFile = File(path.join(mission.savePath, "tmp.zip"));
    tmpFile.deleteSync();
    missionBox.delete(mission.url);
    loadMission();
  }

  Future pauseAll() async {
    Future.wait(downloaderMap.values.map((e) => Future(() => e.cancel())));
    downloaderMap.clear();
    final newMap = Map.of(state.missionQueue);
    for (var mission in newMap.values) {
      mission.state = MissionState.pause;
    }
    emit(state.copyWith(missionQueue: newMap));
  }

  Future pauseMission(MissionInfo mission) async {
    if (downloaderMap.containsKey(mission.url)) {
      await downloaderMap[mission.url]!.cancel();
      downloaderMap.remove(mission.url);
    }
    mission.state = MissionState.pause;
    missionBox.put(mission.url, mission);
    loadMission();
  }

  Future resumeMission(MissionInfo mission) async {
    if (downloaderMap.length < 5) {
      mission.state = MissionState.downloading;
      missionBox.put(mission.url, mission);
      loadMission();
      await startMission(mission);
    } else {
      mission.state = MissionState.waiting;
      missionBox.put(mission.url, mission);
      loadMission();
    }
  }

  Future<bool> createMission(String firstLetter, MissionBindInfo info) async {
    final comicId = info.comicId;
    final chapterId = info.chapterId;
    final url = Api.comicDownload(firstLetter, comicId, chapterId);
    final baseDir = await getApplicationDocumentsDirectory();
    final savePath =
        path.join(baseDir.path,"downloads","comic", comicId.toString(), chapterId.toString());
    final missionInfo = MissionInfo(url: url, savePath: savePath, info: info);
    final newMap = Map.of(state.missionQueue);
    newMap[url] = missionInfo;
    missionBox.put(url, missionInfo);
    loadMission();
    return true;
  }

  Future<void> startMission(MissionInfo mission) async {
    if(state.status.isStop){
      emit(state.copyWith(status: ComicDownloaderStatus.start));
    }
    final downloaderUtils = DownloaderUtils(
      progressCallback: (current, total) {
        mission.progress = current;
        mission.total = total;
        missionBox.put(mission.url, mission);
        final newMap = Map.of(state.missionQueue);
        newMap.update(
          mission.url,
              (value) => value.copyWith(progress: current),
        );
        emit(state.copyWith(missionQueue: newMap));
      },
      client: Dio(BaseOptions(headers: downloadHeader)),
      file: File(path.join(mission.savePath, "tmp.zip")),
      progress: progress,
      onDone: () =>
          {handleDownloadDone(mission.url, mission.savePath, mission.info)},
      deleteOnCancel: false,
    );
    final core = await Flowder.download(
        mission.url,
        downloaderUtils);
    downloaderMap[mission.url] = core;
    final newMap = Map.of(state.missionQueue);
    newMap.update(
      mission.url,
          (value) => value.copyWith(state: MissionState.downloading),
    );
  }

  void handleDownloadDone(
      String url, String savePath, MissionBindInfo info) async {
    final newMap = Map.of(state.missionQueue);
    newMap.update(
      url,
      (value) => value.copyWith(state: MissionState.extracting),
    );
    emit(state.copyWith(missionQueue: newMap));
    await extractFileToDisk(path.join(savePath, "tmp.zip"), savePath);
    late LocalComic localComic;
    if (localComicBox.containsKey(info.comicId)) {
      localComic = localComicBox.get(info.comicId);
    } else {
      localComic = LocalComic(
          comicId: info.comicId,
          comicTitle: info.comicTitle,
          cover: info.cover,
          chapters: []);
    }
    final localChapter = LocalChapter(
      chapterId: info.chapterId,
      chapterTitle: info.chapterTitle,
      order: info.order,
    );
    localComic.chapters.add(localChapter);
    localComic.chapters.sort((a, b) => a.order.compareTo(b.order));
    Future.delayed(Duration(seconds: 5));
    await localComicBox.put(info.comicId, localComic);
    await missionBox.delete(url);
    final newMap1 = Map.of(state.missionQueue);
    newMap1.remove(url);
    emit(state.copyWith(missionQueue: newMap1));
    handleNext();
  }

  void handleNext() {
    if (state.status.isStart) {
      try {
        final nextMission = state.missionQueue.values
            .firstWhere((element) => element.state == MissionState.waiting);
        startMission(nextMission);
      } on StateError {
        emit(state.copyWith(status: ComicDownloaderStatus.stop));
      }
    }
  }
}
