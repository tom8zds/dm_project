import 'dart:async';

import 'api.dart';
import 'api_models/comic/comic_category_model.dart';
import 'api_models/comic/comic_home_model.dart';
import 'api_models/protobuf/comic/detail_response.pb.dart';
import 'api_models/protobuf/comic/rank_list_response.pb.dart';
import 'api_models/protobuf/comic/update_list_response.pb.dart';
import 'api_util.dart';
import 'http_util.dart';

class ComicApi {
  static late ComicApi instance = ComicApi();

  ComicApi(){
    print("new comic api instance");
  }

  //首页
  Future<List<RecommendList>> getHomeList() async {
    String? result = await HttpUtil.instance.httpGet(Api.comicRecommend);
    if (result != null) {
      List<RecommendList> data = recommendListFromMap(result);
      return data;
    } else {
      throw AppError("发生错误");
    }
  }

  Future<ComicCategoryList> getCategoryList() async {
    String? result = await HttpUtil.instance.httpGet(Api.comicCategory());
    if (result != null) {
      ComicCategoryList data = comicCategoryListFromMap(result);
      return data;
    } else {
      throw AppError("发生错误");
    }
  }

  Future<List<ComicCategoryDetailItem>> getCategoryDetail(
      {List<int> tags = const [0, 0, 0, 0]}) async {
    String? result =
        await HttpUtil.instance.httpGet(Api.comicCategoryDetail(tags));
    if (result != null) {
      List<ComicCategoryDetailItem> data =
          comicCategoryDetailItemFromMap(result);
      return data;
    } else {
      throw AppError("发生错误");
    }
  }

  Future<List<ComicCategoryFilter>> getCategoryFilterList() async {
    String? result = await HttpUtil.instance.httpGet(Api.comicCategoryFilter());
    if (result != null) {
      List<ComicCategoryFilter> data = comicCategoryFilterFromMap(result);
      return data;
    } else {
      throw AppError("发生错误");
    }
  }

  /// 首页-更新
  Future<List<ComicUpdateListItemResponse>> getUpdateList(int type,
      {int page = 1}) async {
    var path = "${ApiUtil.BASE_URL_V4}/comic/update/list/$type/$page";
    var result = await (HttpUtil.instance.httpGet(
      path,
      queryParameters: ApiUtil.defaultParameter(needLogined: true),
    ));
    var resultBytes = ApiUtil.decrypt(result!);

    var data = ComicUpdateListResponse.fromBuffer(resultBytes);
    if (data.errno != 0) {
      throw AppError(data.errmsg);
    }
    return data.data;
  }

  /// 漫画详情
  Future<ComicDetailInfoResponse> getDetail(int comicId) async {
    var path = "${ApiUtil.BASE_URL_V4}/comic/detail/$comicId";
    var result = await (HttpUtil.instance.httpGet(
      path,
      queryParameters: ApiUtil.defaultParameter(needLogined: true),
    ));
    var resultBytes = ApiUtil.decrypt(result!);

    var data = ComicDetailResponse.fromBuffer(resultBytes);
    if (data.errno != 0) {
      throw AppError(data.errmsg, code: data.errno);
    }
    return data.data;
  }

  /// 首页-排行榜
  Future<List<ComicRankListItemResponse>> getRankList(
      {int tagId = 0, int byTime = 0, int? rankType, int page = 0}) async {
    var path = "${ApiUtil.BASE_URL_V4}/comic/rank/list";
    var par = ApiUtil.defaultParameter(needLogined: true);
    par.addAll({
      'tag_id': tagId,
      'by_time': byTime,
      'rank_type': rankType,
      'page': page
    });
    var result = await (HttpUtil.instance.httpGet(
      path,
      queryParameters: par,
    ));
    var resultBytes = ApiUtil.decrypt(result!);

    var data = ComicRankListResponse.fromBuffer(resultBytes);
    if (data.errno != 0) {
      throw AppError(data.errmsg);
    }
    return data.data;
  }
}
