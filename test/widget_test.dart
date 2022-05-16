// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/comic_category_model.dart';
import 'package:dmapicore/api/api_models/comic/comic_collection_model.dart';
import 'package:dmapicore/api/api_models/comic/comic_home_model.dart';
import 'package:dmapicore/api/api_models/comic/reader/comic_chapter_model.dart';
import 'package:dmapicore/api/api_models/comic/reader/comic_viewpoint_model.dart';
import 'package:dmapicore/api/api_models/downloader/chunk_info.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/rank_list_response.pb.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/update_list_response.pb.dart';
import 'package:dmapicore/api/api_models/user/user_login.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/api/downloader.dart';
import 'package:dmapicore/api/http_util.dart';
import 'package:dmapicore/api/user_api.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hive/hive.dart';

void main() {
  test("home api test", () async {
    List<RecommendList> data = await ComicApi.instance.getHomeList();
    expect(data, isNotNull);
    print("home api success");
  });
  test("category api test", () async {
    ComicCategoryList data = await ComicApi.instance.getCategoryList();
    expect(data, isNotNull);
    print("category api success");
  });
  test("category filter test", () async {
    List<ComicCategoryFilter> data =
        await ComicApi.instance.getCategoryFilterList();
    expect(data, isNotNull);
    data.forEach((element) {
      print(element.items![0].tagId);
    });
    print("category api success");
  });
  test("novel recomment api test", () async {
    List<ComicCategoryDetailItem> data =
        await ComicApi.instance.getCategoryDetail();
    expect(data, isNotNull);
    print(data[0].toMap());
    print("novel recomment api success");
  });

  test("category detail api test", () async {
    String? data = await HttpUtil.instance.httpGet(Api.novelRecommend);
    List<RecommendList> list = recommendListFromMap(data!);
    expect(list, isNotNull);
    print(list[0].toMap());
    print("category api success");
  });
  test("collection list api test", () async {
    ComicCollectionResponse data = await ComicApi.instance.getCollectionList();
    expect(data, isNotNull);
    print(data.data[0].toMap());
    print("category api success");
  });
  test("collection detail api test", () async {
    ComicCollectionContent data =
        await ComicApi.instance.getCollectionContent(0);
    expect(data, isNotNull);
    print(data.toMap());
    print("category api success");
  });
  test("rank api test", () async {
    List<ComicRankListItemResponse> data =
        await ComicApi.instance.getRankList();
    print(data[0].title);
    print(data[0].chapterName);
    expect(data, isNotNull);
    print("rank api success");
  });
  test("update api test", () async {
    List<ComicUpdateListItemResponse> data =
        await ComicApi.instance.getUpdateList(0);
    print(data[0].title);
    print(data[0].lastUpdateChapterName);
    expect(data, isNotNull);
    print("update api success");
  });
  test("detail api test", () async {
    int comicId = 39472;
    ComicDetailInfoResponse data = await ComicApi.instance.getDetail(comicId);
    print(data.title);
    print(data.description);
    print(data.toDebugString());
    expect(data, isNotNull);
    print("detail api success");
  });
  test("download api test", () async {
    int comicId = 39472;
    ComicDetailInfoResponse data = await ComicApi.instance.getDetail(comicId);
    print(data.title);
    print(data.firstLetter);
    print(data.chapters.first.title);

    int chapterId = data.chapters.first.data.first.chapterId;

    String api = Api.comicDownload(data.firstLetter, data.id, chapterId);
    print(api);

    String path = "./test/$comicId/$chapterId/";

    Hive.deleteFromDisk();
    Hive.registerAdapter(MissionInfoAdapter());
    Hive.registerAdapter(ChunkInfoAdapter());
    Hive.init("./test");
    Box box = await Hive.openBox("test");

    ComicDownloader downloader = ComicDownloader(
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('${(received / total * 100).floor()}%');
        }
      },
      options: Options(
        headers: {
          "Referer": "http://images.muwai.com/",
          "Host": "imgzip.muwai.com",
          "Connection": "Keep-Alive",
          "Accept-Encoding": "gzip",
          "User-Agent": "okhttp/3.12.1",
        },
      ),
    );

    bool flag = await downloader.createMission(
      api,
      path,
    );

    expect(flag, true);

    print("mission created");

    List<MissionInfo> missionList = await downloader.missionDao.getAllMission();

    expect(missionList[0], isNotNull);

    print(missionList[0].toString());

    flag = await downloader.downloadMission(api);

    expect(flag, true);

    Directory dir = Directory(path);

    expect(dir.existsSync(), true);

    print(dir.listSync());

    Hive.close();
    Hive.deleteFromDisk();

    print("download api success");
  });
  test("chapter api test", () async {
    Hive.init("./test");
    await Hive.openBox(comicApiBoxKey);
    int comicId = 40135;
    ComicDetailInfoResponse data = await ComicApi.instance.getDetail(comicId);
    expect(data, isNotNull);
    print(data.title);
    print(data.description);
    final chapterId = data.chapters[0].data[0].chapterId;
    String? chapterData = await HttpUtil.instance
        .httpGet(Api.comicChapterDetail(data.id, chapterId));
    String? chapterWebData = await HttpUtil.instance
        .httpGet(Api.comicWebChapterDetail(data.id, chapterId));
    String? chapterViewPoint = await HttpUtil.instance
        .httpGet(Api.comicChapterViewPoint(data.id, chapterId));
    expect(chapterData, isNotNull);
    expect(chapterWebData, isNotNull);
    expect(chapterViewPoint, isNotNull);
    print(chapterData);
    print(chapterWebData);
    print(chapterViewPoint);
    print(ComicChapterData.fromJson(json.decode(chapterData!)));
    print(ComicChapterData.fromJson(json.decode(chapterWebData!)));
    print(comicViewPointFromJson(chapterViewPoint!));
    print("detail api success");
  });

  test("login api test", () async {
    UserLoginResponse response_fail = await UserApi.instance
        .doLogin(username: "testuser", password: "testpasswd");

    expect(response_fail.result, 0);
    print(response_fail.toMap());

    print("login api success");
  });

  test("hive test", () async {
    Hive.deleteFromDisk();
    Hive.init("./test");
    Box box = await Hive.openBox("test");

    box.put('name', 'David');

    print('Name: ${box.get('name')}');

    Hive.close();
    Hive.deleteFromDisk();
    print("hive api success");
  });
}
