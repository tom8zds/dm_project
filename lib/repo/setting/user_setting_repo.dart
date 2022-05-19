import 'dart:convert';

import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/setting/app_config_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserSettingRepo {
  final Box settingBox = Hive.box(_settingKey);

  static const String _settingKey = settingBoxKey;

  static UserSettingRepo? _settingRepo;

  static UserSettingRepo get instance => _settingRepo ??= UserSettingRepo();

  UserSettingRepo();

  AppConfig getUserData() {
    settingBox.delete(_settingKey);
    if (settingBox.containsKey(_settingKey)) {
      Map<String, dynamic> json = jsonDecode(settingBox.get(_settingKey));
      return AppConfig.fromJson(json);
    }
    settingBox.put(
      _settingKey,
      jsonEncode(
        const AppConfig().toJson(),
      ),
    );
    return AppConfig.fromJson(jsonDecode(settingBox.get(_settingKey)));
  }

  void setUserData(AppConfig newData) {
    settingBox.put(_settingKey, newData.toJson());
  }
}
