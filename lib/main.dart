import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'views/home_page.dart';

void main() {
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => ClassicHeader(
          idleText: "下拉刷新",
          releaseText: '释放刷新',
          refreshingText: '正在加载',
          completeText: '加载完成',
          failedText: '加载失败'), // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
      footerBuilder: () => ClassicFooter(
        canLoadingText: '释放加载',
        loadingText: '正在加载',
        idleText: '上拉加载',
        failedText: '加载失败',
        noDataText: '后面没有了',
      ), // 配置默认底部指示器
      enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
      hideFooterWhenNotFull: true, // Viewport不满一屏时,禁用上拉加载更多功能
      enableBallisticLoad: false, // 可以通过惯性滑动触发加载更多

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        home: HomePageView(),
      ),
    );
  }
}
