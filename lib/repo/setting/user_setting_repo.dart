import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/setting/app_config_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserSettingRepo {
  final Box settingBox = Hive.box(_settingKey);

  static const String _settingKey = AppConstants.settingBoxKey;

  static UserSettingRepo? _settingRepo;

  static UserSettingRepo get instance => _settingRepo ??= UserSettingRepo();

  UserSettingRepo();

  AppConfig getUserData() {
    Map<String, dynamic> json = settingBox.get(_settingKey);
    if (json == null) {
      settingBox.put(_settingKey, AppConfig().toJson());
      return settingBox.get(_settingKey);
    }
    return AppConfig.fromJson(json);
  }

  void setUserData(AppConfig newData) {
    settingBox.put(_settingKey, newData.toJson());
  }
}
