import 'dart:io';

import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/model/setting/app_config_model.dart';
import 'package:dmapicore/repo/setting/user_setting_repo.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      await loadSystemThemeColor();
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
      return modes;
    } on Exception {
      return [];
    }
  }

  void toggleThemeMode() {
    final themeMode = state.appConfig.themeMode;
    emit(
      state.copyWith(
        appConfig: state.appConfig.copyWith(
          themeMode: ThemeMode.values.elementAt((themeMode.index + 1) % 3),
        ),
      ),
    );
  }

  void changeColorSeed(int colorSeed, {String? title}) {
    emit(
      state.copyWith(
          appConfig:
              state.appConfig.copyWith(colorSeed: colorSeed, isSysColor: false),
          themeName: title),
    );
    handleThemeColor();
  }

  Future toggleThemeColorMode({bool isSystem = true}) async {
    if (isSystem == state.appConfig.isSysColor) {
      return;
    }
    emit(
      state.copyWith(
        appConfig: state.appConfig.copyWith(
          isSysColor: isSystem,
        ),
      ),
    );
    await handleThemeColor();
  }

  Future loadSystemThemeColor() async {
    if (Platform.isAndroid) {
      final systemCorePalette = await DynamicColorPlugin.getCorePalette();
      if (systemCorePalette != null) {
        final systemLightScheme = systemCorePalette.toColorScheme();
        final systemDarkScheme =
            systemCorePalette.toColorScheme(brightness: Brightness.dark);
        emit(
          state.copyWith(
            themeName: "跟随系统",
            appDarkScheme: systemDarkScheme,
            appLightScheme: systemLightScheme,
            sysLightScheme: systemLightScheme,
            sysDarkScheme: systemDarkScheme,
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
            themeName: "跟随系统",
            appDarkScheme: systemDarkScheme,
            appLightScheme: systemLightScheme,
            sysLightScheme: systemLightScheme,
            sysDarkScheme: systemDarkScheme,
          ),
        );
      }
    }
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
          themeName: themeColorNames.elementAt(
            themeColors.indexOf(state.appConfig.colorSeed),
          ),
          appDarkScheme: systemDarkScheme,
          appLightScheme: systemLightScheme,
        ),
      );
      return;
    }
    if (state.sysLightScheme == null) {
      await loadSystemThemeColor();
    } else {
      emit(
        state.copyWith(
          themeName: "跟随系统",
          appDarkScheme: state.sysDarkScheme,
          appLightScheme: state.sysLightScheme,
        ),
      );
    }
  }
}
