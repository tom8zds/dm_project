import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:dmapicore/api/api_models/downloader/mission_dao.dart';
import 'package:hive/hive.dart';

import 'api_models/downloader/chunk_info.dart';

class ComicDownloader {
  // 初始化 计算分块数量 初始化分块任务集合
  // 下载 从分块中下载
  // 停止 手动/出错 停止下载 cancel 正在下载的分块还在列队中
  // 完成 列队清空 合并分块 解压
  /// Downloading by spiting as file in chunks

  static const firstChunkSize = 102;
  static const maxChunk = 3;
  Dio dio = Dio();
  final MissionDao missionDao = MissionDao.instance;

  Options? options;
  ProgressCallback? onReceiveProgress;
  CancelToken? cancelToken;

  ComicDownloader(
      {this.options,
      this.onReceiveProgress,
      this.cancelToken,});

  Future<bool> downloadMission(String url) async {
    MissionInfo mission = await missionDao.getMission(url);
    int counter = 0;
    for (var chunk in mission.chunkList) {
      if (mission.state == 2) {
        print("mission stop");
        break;
      }
      if (chunk.state == 1) {
        counter += 1;
      } else {
        if (chunk.state == 0) {
          Response response = await downloadChunk(chunk, mission.savePath,
              receiveCallback: createCallback(mission.progress, mission.total));
          if (response.statusCode == 206) {
            mission.progress = chunk.end;
            await missionDao.putMission(mission);
            counter += 1;
          }
        }
      }

      mission = await missionDao.getMission(url);
    }
    if (counter == mission.chunkList.length) {
      await mergeTempFiles(mission);
      await extractFileToDisk("${mission.savePath}tmp.zip", mission.savePath);

      mission.state = 1;
      missionDao.putMission(mission);

      print("mission complete");
      return true;
    }
    return false;
  }

  Future<Response> downloadChunk(ChunkInfo chunkInfo, String savePath,
      {Function(int, int)? receiveCallback}) async {
    var url = chunkInfo.url;
    var start = chunkInfo.start;
    var end = chunkInfo.end;
    var no = chunkInfo.order;
    --end;
    if (options != null) {
      options!.headers!.addAll({'range': 'bytes=$start-$end'});
    }
    Response response = await dio.download(
      url,
      '${savePath}temp$no',
      onReceiveProgress: receiveCallback,
      cancelToken: cancelToken,
      deleteOnError: true,
      options: options ??
          Options(
            headers: {'range': 'bytes=$start-$end'},
          ),
    );
    if (response.statusCode == 206) {
      chunkInfo.state = 1;
    }
    return response;
  }

  void Function(int, int) createCallback(missionProgress, total) {
    return (int received, int _) {
      if (onReceiveProgress != null && total != 0) {
        onReceiveProgress!(missionProgress + received, total);
      }
    };
  }

  Future<void> mergeTempFiles(MissionInfo mission) async {
    var savePath = mission.savePath;
    var chunk = mission.chunkList.length;

    var f = File('${savePath}temp0');
    var ioSink = f.openWrite(mode: FileMode.writeOnlyAppend);
    for (var i = 1; i < chunk; ++i) {
      var f = File('${savePath}temp$i');
      await ioSink.addStream(f.openRead());
      await f.delete();
    }
    await ioSink.close();
    await f.rename("${savePath}tmp.zip");
  }

  Future<bool> createMission(String url, String savePath) async {
    ChunkInfo firstChunk =
        ChunkInfo(url: url, start: 0, end: firstChunkSize, order: 0);
    List<ChunkInfo> chunkList = [];
    MissionInfo mission =
        MissionInfo(url: url, savePath: savePath, chunkList: chunkList);
    var response = await downloadChunk(firstChunk, savePath);
    if (response.statusCode == 206) {
      var total = int.parse(response.headers
          .value(HttpHeaders.contentRangeHeader)!
          .split('/')
          .last);
      mission.total = total;
      mission.chunkList.add(firstChunk);
      var reserved = total -
          int.parse(response.headers.value(Headers.contentLengthHeader)!);
      var chunk = (reserved / firstChunkSize).ceil() + 1;
      if (chunk > 1) {
        var chunkSize = firstChunkSize;
        if (chunk > maxChunk + 1) {
          chunk = maxChunk + 1;
          chunkSize = (reserved / maxChunk).ceil();
        }

        for (var i = 0; i < maxChunk; ++i) {
          var start = firstChunkSize + i * chunkSize;
          chunkList.add(ChunkInfo(
              url: url, start: start, end: start + chunkSize, order: i + 1));
        }
        await missionDao.addMission(mission);
        return true;
      }
    }
    return false;
  }
}
