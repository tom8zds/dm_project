import 'dart:io';

import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/reader/comic_chapter_model.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/api/http_util.dart';
import 'package:dmapicore/model/comic/comic_detail_model.dart';
import 'package:dmapicore/model/comic/comic_reader_chapter_model.dart';

import 'package:path/path.dart' as path;

class ComicChapterRepo {
  Future<ComicReaderChapter> getComicChapter(
      String firstLetter, int comicId, ComicChapter chapter) async {
    final chapterId = chapter.chapterId;
    try {
      ComicChapterData data =
          await ComicApi.instance.getChapterData(comicId, chapterId);
      if (data.pageUrl.length != data.picNum) {
        data = await ComicApi.instance
            .getChapterData(comicId, chapterId, isWeb: false);
      }
      String url = Api.comicDownload(firstLetter, comicId, chapterId);
      // if (MissionDao.instance.missionBox.containsKey(url)) {
      //   MissionInfo info = await MissionDao.instance.getMission(url);
      //   Directory dir = Directory(info.savePath);
      //   if(dir.existsSync()){
      //     List<String> newList = [];
      //     dir.listSync().forEach((element) {
      //       if(path.extension(element.path) != ".zip"){
      //         newList.add(element.path);
      //       }
      //     });
      //     newList.sort();
      //     return ComicChapter(data: data.copyWith(pageUrl: newList), isLocal: true);
      //   }
      //
      // }
      return ComicReaderChapter(data: data, isLocal: false);
    } on Exception {
      throw AppError("章节加载失败");
    }
  }
}
