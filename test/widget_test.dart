// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dmapicore/api/api.dart';
import 'package:dmapicore/api/api_models/comic/comic_category_model.dart';
import 'package:dmapicore/api/api_models/comic/comic_home_model.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/rank_list_response.pb.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/update_list_response.pb.dart';
import 'package:dmapicore/api/api_models/user/user_login.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/api/http_util.dart';
import 'package:dmapicore/api/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dmapicore/main.dart';
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
  test("category detail api test", () async {
    List<ComicCategoryDetailItem> data =
        await ComicApi.instance.getCategoryDetail();
    expect(data, isNotNull);
    print(data[0].toMap());
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
    int comicId = 40135;
    ComicDetailInfoResponse data = await ComicApi.instance.getDetail(comicId);
    print(data.title);
    print(data.description);
    expect(data, isNotNull);
    print("detail api success");
  });
  test("chapter api test", () async {
    int comicId = 40135;
    ComicDetailInfoResponse data = await ComicApi.instance.getDetail(comicId);
    print(data.title);
    print(data.description);
    expect(data, isNotNull);
    print("detail api success");
  });

  test("login api test", () async {

    UserLoginResponse response_fail = await UserApi.instance.doLogin(username: "testuser", password: "testpasswd");

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
