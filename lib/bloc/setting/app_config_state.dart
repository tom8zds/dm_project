part of 'app_config_cubit.dart';

extension ThemeModeX on ThemeMode {
  String getTitle() {
    switch (this) {
      case ThemeMode.system:
        return "跟随系统";
      case ThemeMode.light:
        return "浅色模式";
      case ThemeMode.dark:
        return "夜间模式";
    }
  }

  IconData getIcon() {
    switch (this) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.brightness_5;
      case ThemeMode.dark:
        return Icons.brightness_4;
    }
  }
}

class AppConfigState extends Equatable {
  final AppConfig appConfig;
  final Iterable<DisplayMode> displayModeList;
  final LoadStatus status;

  const AppConfigState(
      {this.appConfig = const AppConfig(),
      this.status = LoadStatus.initial,
      this.displayModeList = const Iterable.empty()});

  AppConfigState copyWith(
      {AppConfig? appConfig,
      LoadStatus? status,
      Iterable<DisplayMode>? displayModeList}) {
    return AppConfigState(
      appConfig: appConfig ?? this.appConfig,
      status: status ?? this.status,
      displayModeList: displayModeList ?? this.displayModeList,
    );
  }

  @override
  List<Object> get props => [appConfig, status, displayModeList];
}
