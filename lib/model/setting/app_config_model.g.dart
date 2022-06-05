// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      comicReaderConfig: json['comicReaderConfig'] == null
          ? const ComicReaderConfig()
          : ComicReaderConfig.fromJson(
              json['comicReaderConfig'] as Map<String, dynamic>),
      novelReaderConfig: json['novelReaderConfig'] == null
          ? const NovelReaderConfig()
          : NovelReaderConfig.fromJson(
              json['novelReaderConfig'] as Map<String, dynamic>),
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      colorSeed: json['colorSeed'] as int? ?? 0xff6750a4,
      displayMode: json['displayMode'] == null
          ? DisplayMode.auto
          : const DisplayModeConverter()
              .fromJson(json['displayMode'] as Map<String, dynamic>),
      username: json['username'] as String?,
      password: json['password'] as String?,
      isSysColor: json['isSysColor'] as bool? ?? false,
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'comicReaderConfig': instance.comicReaderConfig.toJson(),
      'novelReaderConfig': instance.novelReaderConfig.toJson(),
      'displayMode': const DisplayModeConverter().toJson(instance.displayMode),
      'themeMode': _$ThemeModeEnumMap[instance.themeMode],
      'isSysColor': instance.isSysColor,
      'colorSeed': instance.colorSeed,
      'username': instance.username,
      'password': instance.password,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

ReaderConfig _$ReaderConfigFromJson(Map<String, dynamic> json) => ReaderConfig(
      scrollMode:
          $enumDecodeNullable(_$ScrollModeEnumMap, json['scrollMode']) ??
              ScrollMode.auto,
      isDoublePage: json['isDoublePage'] as bool? ?? false,
      isReverse: json['isReverse'] as bool? ?? false,
    );

Map<String, dynamic> _$ReaderConfigToJson(ReaderConfig instance) =>
    <String, dynamic>{
      'scrollMode': _$ScrollModeEnumMap[instance.scrollMode],
      'isDoublePage': instance.isDoublePage,
      'isReverse': instance.isReverse,
    };

const _$ScrollModeEnumMap = {
  ScrollMode.landscape: 'landscape',
  ScrollMode.portrait: 'portrait',
  ScrollMode.auto: 'auto',
};

ComicReaderConfig _$ComicReaderConfigFromJson(Map<String, dynamic> json) =>
    ComicReaderConfig();

Map<String, dynamic> _$ComicReaderConfigToJson(ComicReaderConfig instance) =>
    <String, dynamic>{};

NovelReaderConfig _$NovelReaderConfigFromJson(Map<String, dynamic> json) =>
    NovelReaderConfig();

Map<String, dynamic> _$NovelReaderConfigToJson(NovelReaderConfig instance) =>
    <String, dynamic>{};
