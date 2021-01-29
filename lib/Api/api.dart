import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:dm_project/Api/api_models/comic/comic_collection_model.dart';

enum PageState { loading, done, fail }

class Api {
  static final String apiHost = "https://v3api.dmzj1.com";
  static final String channel = Platform.operatingSystem;
  static final String version = "1.1.0";
  static final String appChannel = '101_01_01_071';
  static final int _debug = 0;
  static get timeStamp =>
      (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0);

  //漫画主页
  static String get comicHome =>
      '$apiHost/recommend_new_game.json?$defaultParameter';
  //小说主页
  static String get novelHome =>
      '$apiHost/novel/recommend.json?$defaultParameter';

  static String comicBatchUpdate(int categoryId) {
    return "$apiHost/recommend/batchUpdate?category_id=$categoryId&$defaultParameter";
  }

  //漫画分类过滤器
  static String get comicCatagoryFilter =>
      '$apiHost/classify/filter.json?$defaultParameter';

  //漫画分类 分类-面向人群-连载状态-地域
  static String comicCatagory(List<String> typeIds, int page, int orderType) {
    String param = '';
    typeIds.forEach((element) {
      if (element != '0') {
        param += '$element-';
      }
    });
    if (param.isEmpty)
      param = '0';
    else
      param = param.substring(0, param.length - 1);
    return '$apiHost/classify/$param/$orderType/$page.json?$defaultParameter';
  }

  //漫画排行过滤器
  static String get comicRankFilter =>
      '$apiHost/rank/type_filter.json?$defaultParameter';

  //漫画排行 分类/时间/排序/页
  static String comicRank(int tag, int timeRage, int orderType, int page) {
    String api;
    if (orderType == 0) {
      api =
          '$apiHost/rank/$tag/$timeRage/$orderType/$page.json?$defaultParameter';
    } else {
      api = '$apiHost/rank/0/$timeRage/$orderType/$page.json?$defaultParameter';
    }
    return api;
  }

  //漫画专题
  static String comicCollection(int page) =>
      '$apiHost/subject/0/$page.json?$defaultParameter';

  static String comicCollectionContent(int id) =>
      '$apiHost/subject/$id.json?$defaultParameter';

  //用户相关
  static get loginV2 => "https://user.dmzj1.com/loginV2/m_confirm";
  static String userProfile(String uid, String token) {
    return "$apiHost/UCenter/comicsv2/$uid.json?dmzj_token=$token&$defaultParameter";
  }

  static String get defaultParameter =>
      "channel=$channel&version$version&timestamp=$timeStamp&_debug=$_debug&app_channel=$appChannel";

  static String sign(String content, String mode) {
    var _content = new Utf8Encoder().convert(mode + content);
    return hex.encode(md5.convert(_content).bytes);
  }
}
