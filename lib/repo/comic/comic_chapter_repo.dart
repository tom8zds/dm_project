import 'dart:io';

import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/reader/comic_chapter_model.dart';
import 'package:dmapicore/api/api_models/downloader/chunk_info.dart';
import 'package:dmapicore/api/api_models/downloader/mission_dao.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/model/comic/comic_volume_model.dart';

class ComicChapterRepo {
  Future<ComicChapter> getComicChapter(
      String firstLetter, int comicId, int chapterId) async {
    final ComicChapterData data =
        await ComicApi.instance.getChapterData(comicId, chapterId);
    String url = Api.comicDownload(firstLetter, comicId, chapterId);
    if (MissionDao.instance.missionBox.containsKey(url)) {
      MissionInfo info = await MissionDao.instance.getMission(url);
      Directory dir = Directory(info.savePath);
      List<String> newList = List.generate(data.picNum, (index) => "${info.savePath}/i${index}");
      return ComicChapter(data :data.copyWith(pageUrl: newList), isLocal: true);
    }
    return ComicChapter(data: data, isLocal: false);
  }
}
