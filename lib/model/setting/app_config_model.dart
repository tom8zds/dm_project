import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reader_config_model.dart';

part 'app_config_model.g.dart';

@JsonSerializable()
class AppConfig extends Equatable {
  final ComicReaderConfig comicReaderConfig;
  final NovelReaderConfig novelReaderConfig;
  final ThemeMode themeMode;
  final int colorSeed;
  final String? username;
  final String? password;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  const AppConfig({
    this.comicReaderConfig = const ComicReaderConfig(),
    this.novelReaderConfig = const NovelReaderConfig(),
    this.themeMode = ThemeMode.system,
    this.colorSeed = 0xff6750a4,
    this.username,
    this.password,
  });

  AppConfig copyWith(
      {ComicReaderConfig? comicReaderConfig,
      NovelReaderConfig? novelReaderConfig,
      ThemeMode? themeMode,
      int? colorSeed,
      String? username,
      String? password}) {
    return AppConfig(
      comicReaderConfig: comicReaderConfig ?? this.comicReaderConfig,
      novelReaderConfig: novelReaderConfig ?? this.novelReaderConfig,
      themeMode: themeMode ?? this.themeMode,
      colorSeed: colorSeed ?? this.colorSeed,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [
        comicReaderConfig,
        novelReaderConfig,
        themeMode,
        colorSeed,
        username,
        password
      ];
}
