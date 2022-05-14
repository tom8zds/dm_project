import 'package:bloc/bloc.dart';
import 'package:dmapicore/model/setting/app_config_model.dart';
import 'package:dmapicore/repo/setting/user_setting_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_config_state.dart';

class AppConfigCubit extends Cubit<AppConfigState> {
  AppConfigCubit() : super(const AppConfigState());

  void fetchData() {
    try {
      emit(state.copyWith(appConfig: UserSettingRepo.instance.getUserData()));
    } on Exception {
      emit(state);
    }
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
}
