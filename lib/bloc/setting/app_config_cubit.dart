import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/model/setting/app_config_model.dart';
import 'package:dmapicore/repo/setting/user_setting_repo.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

part 'app_config_state.dart';

class AppConfigCubit extends Cubit<AppConfigState> {
  AppConfigCubit()
      : super(
            AppConfigState(appConfig: UserSettingRepo.instance.getUserData()));

  Future<void> fetchData() async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final List<DisplayMode> modeList = await checkRefreshRate();
      final DisplayMode m = await FlutterDisplayMode.active;
      await handleThemeColor();
      emit(
        state.copyWith(
          displayModeList: modeList,
          status: LoadStatus.success,
          appConfig:
              UserSettingRepo.instance.getUserData().copyWith(displayMode: m),
        ),
      );
    } on Exception {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  Future<void> changeDiaplayMode(DisplayMode mode) async {
    await FlutterDisplayMode.setPreferredMode(mode);
    emit(
      state.copyWith(
        appConfig: state.appConfig.copyWith(displayMode: mode),
      ),
    );
  }

  Future<List<DisplayMode>> checkRefreshRate() async {
    try {
      final modes = await FlutterDisplayMode.supported;
      modes.forEach(print);
      return modes;

      /// On OnePlus 7 Pro:
      /// #0 0x0 @0Hz // Automatic
      /// #1 1080x2340 @ 60Hz
      /// #2 1080x2340 @ 90Hz
      /// #3 1440x3120 @ 90Hz
      /// #4 1440x3120 @ 60Hz

      /// On OnePlus 8 Pro:
      /// #0 0x0 @0Hz // Automatic
      /// #1 1080x2376 @ 60Hz
      /// #2 1440x3168 @ 120Hz
      /// #3 1440x3168 @ 60Hz
      /// #4 1080x2376 @ 120Hz
    } on Exception {
      /// e.code =>
      /// noAPI - No API support. Only Marshmallow and above.
      /// noActivity - Activity is not available. Probably app is in background
    }
    return [];
  }

  void toggleThemeMode() {
    final themeMode = state.appConfig.themeMode;
    emit(state.copyWith(
        appConfig: state.appConfig.copyWith(
            themeMode: ThemeMode.values.elementAt((themeMode.index + 1) % 3))));
  }

  void changeColorSeed(int colorSeed) {
    emit(state.copyWith(
        appConfig: state.appConfig.copyWith(colorSeed: colorSeed)));
  }

  Future toggleThemeColorMode() async {
    emit(
      state.copyWith(
        appConfig:
            state.appConfig.copyWith(isSysColor: !state.appConfig.isSysColor),
      ),
    );
    await handleThemeColor();
  }

  Future handleThemeColor() async {
    if (!state.appConfig.isSysColor) {
      final systemLightScheme = ColorScheme.fromSeed(
        seedColor: Color(state.appConfig.colorSeed),
      );
      final systemDarkScheme = ColorScheme.fromSeed(
        seedColor: Color(state.appConfig.colorSeed),
        brightness: Brightness.dark,
      );
      emit(
        state.copyWith(
          appDarkScheme: systemDarkScheme,
          appLightScheme: systemLightScheme,
        ),
      );
      return;
    }
    if (Platform.isAndroid) {
      final systemCorePalette = await DynamicColorPlugin.getCorePalette();
      if (systemCorePalette != null) {
        final systemLightScheme = systemCorePalette.toColorScheme();
        final systemDarkScheme = systemCorePalette.toColorScheme(brightness: Brightness.dark);
        emit(
          state.copyWith(
            appDarkScheme: systemDarkScheme,
            appLightScheme: systemLightScheme,
          ),
        );
      }
    } else {
      final systemColor = await DynamicColorPlugin.getAccentColor();
      if (systemColor != null) {
        final systemLightScheme = ColorScheme.fromSeed(
          seedColor: systemColor,
        );
        final systemDarkScheme = ColorScheme.fromSeed(
          seedColor: systemColor,
          brightness: Brightness.dark,
        );
        emit(
          state.copyWith(
            appDarkScheme: systemDarkScheme,
            appLightScheme: systemLightScheme,
          ),
        );
      }
    }
  }
}
