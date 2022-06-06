import 'package:dmapicore/bloc/setting/app_config_cubit.dart';
import 'package:dmapicore/model/comic/comic_local_model.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/model/downloader/comic_download_model.dart';
import 'package:dmapicore/repo/setting/user_setting_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/comic/local_comic/local_comic_cubit.dart';
import 'bloc/downloader/comic_downloader_cubit.dart';
import 'firebase_options.dart';
import 'internal/app_constants.dart';
import 'views/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await Hive.initFlutter();
  await openBoxes();
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigCubit>(
          create: (BuildContext context) => AppConfigCubit(),
        ),
        BlocProvider<ComicDownloaderCubit>(
          create: (BuildContext context) => ComicDownloaderCubit(),
        ),
        BlocProvider<LocalComicCubit>(
          create: (context) => LocalComicCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

Future<void> openBoxes() async {
  Hive.registerAdapter(MissionInfoAdapter());
  Hive.registerAdapter(MissionBindInfoAdapter());
  Hive.registerAdapter(LocalChapterAdapter());
  Hive.registerAdapter(LocalComicAdapter());
  Hive.registerAdapter(MissionStateAdapter());
  for (var key in initBoxes) {
    await Hive.openBox(key);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () =>
      const ClassicHeader(
          idleText: "下拉刷新",
          releaseText: '释放刷新',
          refreshingText: '正在加载',
          completeText: '加载完成',
          failedText: '加载失败'),
      // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
      footerBuilder: () =>
      const ClassicFooter(
        canLoadingText: '释放加载',
        loadingText: '正在加载',
        idleText: '上拉加载',
        failedText: '加载失败',
        noDataText: '后面没有了',
      ),
      // 配置默认底部指示器
      enableLoadingWhenFailed: true,
      //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
      hideFooterWhenNotFull: false,
      // Viewport不满一屏时,禁用上拉加载更多功能
      enableBallisticLoad: false,
      // 可以通过惯性滑动触发加载更多

      child: BlocConsumer<AppConfigCubit, AppConfigState>(
          listener: (context, state) {
            UserSettingRepo.instance.setUserData(state.appConfig);
          },
          builder: (context, state) {
            if (state.status.isInitial) {
              context.read<AppConfigCubit>().fetchData();
            }
            return MaterialApp(
              title: 'Flutter Demo',
              themeMode: state.appConfig.themeMode,
              theme: ThemeData.light().copyWith(
                useMaterial3: true,
                colorScheme: state.appLightScheme ?? ColorScheme.fromSeed(
                  seedColor: Color(
                    state.appConfig.colorSeed,
                  ),
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                useMaterial3: true,
                colorScheme: state.appDarkScheme ?? ColorScheme.fromSeed(
                  seedColor: Color(state.appConfig.colorSeed),
                  brightness: Brightness.dark,
                ),
              ),
              home: HomePageView(),
            );
          }),
    );
  }
}
