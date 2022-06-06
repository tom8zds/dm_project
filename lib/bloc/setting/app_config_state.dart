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
  final ColorScheme? appLightScheme;
  final ColorScheme? appDarkScheme;
  final ColorScheme? sysLightScheme;
  final ColorScheme? sysDarkScheme;
  final String themeName;

  const AppConfigState({this.appConfig = const AppConfig(),
    this.status = LoadStatus.initial,
    this.displayModeList = const Iterable.empty(),
    this.appLightScheme, this.appDarkScheme,this.sysLightScheme, this.sysDarkScheme, this.themeName = ""});

  @override
  List<Object?> get props =>
      [appConfig, displayModeList, status, appLightScheme, appDarkScheme,];

  AppConfigState copyWith({
    AppConfig? appConfig,
    Iterable<DisplayMode>? displayModeList,
    LoadStatus? status,
    ColorScheme? appLightScheme,
    ColorScheme? appDarkScheme,
    ColorScheme? sysLightScheme,
    ColorScheme? sysDarkScheme,
    String? themeName,
  }) {
    return AppConfigState(
      appConfig: appConfig ?? this.appConfig,
      displayModeList: displayModeList ?? this.displayModeList,
      status: status ?? this.status,
      appLightScheme: appLightScheme ?? this.appLightScheme,
      appDarkScheme: appDarkScheme ?? this.appDarkScheme,
      sysLightScheme: sysLightScheme ?? this.sysLightScheme,
      sysDarkScheme: sysDarkScheme ?? this.sysDarkScheme,
      themeName: themeName ?? this.themeName,
    );
  }
}
