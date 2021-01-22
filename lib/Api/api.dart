import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

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
    print('$apiHost/classify/$param/$orderType/$page.json?$defaultParameter');
    return '$apiHost/classify/$param/$orderType/$page.json?$defaultParameter';
  }

  //漫画排行过滤器
  static String get comicRankFilter =>
      '$apiHost/rank/type_filter.json?$defaultParameter';

  static String get defaultParameter =>
      "channel=$channel&version$version&timestamp=$timeStamp&_debug=$_debug&app_channel=$appChannel";

  static String sign(String content, String mode) {
    var _content = new Utf8Encoder().convert(mode + content);
    return hex.encode(md5.convert(_content).bytes);
  }
}
