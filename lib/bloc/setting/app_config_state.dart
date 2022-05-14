part of 'app_config_cubit.dart';

enum LoginState {
  empty,
  loading,
  success,
  failure,
}

extension ThemeModeX on ThemeMode{
  String getTitle(){
    switch(this){
      case ThemeMode.system:
        return "跟随系统";
      case ThemeMode.light:
        return "浅色模式";
      case ThemeMode.dark:
        return "夜间模式";
    }
  }
  IconData getIcon(){
    switch(this){
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

  final LoginState loginState;

  const AppConfigState(
      {this.appConfig = const AppConfig(), this.loginState = LoginState.empty});

  AppConfigState copyWith({AppConfig? appConfig, LoginState? loginState}) {
    return AppConfigState(
      appConfig: appConfig ?? this.appConfig,
      loginState: loginState ?? this.loginState,
    );
  }

  @override
  List<Object> get props => [appConfig, loginState];
}
