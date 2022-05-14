part of 'app_config_model.dart';

enum ScrollMode {
  @JsonKey(name: "landscape")
  landscape,
  @JsonKey(name: "portrait")
  portrait,
  @JsonKey(name: "auto")
  auto,
}

extension ScrollModeX on ScrollMode {
  String getTitle() {
    switch (this) {
      case ScrollMode.landscape:
        return "横向";
      case ScrollMode.portrait:
        return "纵向";
      case ScrollMode.auto:
        return "自动";
    }
  }
}

@JsonSerializable()
class ReaderConfig extends Equatable {
  final ScrollMode scrollMode;
  final bool isDoublePage;
  final bool isReverse;

  const ReaderConfig(
      {this.scrollMode = ScrollMode.auto,
      this.isDoublePage = false,
      this.isReverse = false});

  ReaderConfig copyWith(
      {ScrollMode? scrollMode, bool? isDoublePage, bool? isReverse}) {
    return ReaderConfig(
      scrollMode: scrollMode ?? this.scrollMode,
      isDoublePage: isDoublePage ?? this.isDoublePage,
      isReverse: isReverse ?? this.isReverse,
    );
  }

  factory ReaderConfig.fromJson(Map<String, dynamic> json) =>
      _$ReaderConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ReaderConfigToJson(this);

  @override
  List<Object?> get props => [scrollMode, isDoublePage, isReverse];
}

@JsonSerializable()
class ComicReaderConfig extends ReaderConfig {
  const ComicReaderConfig() : super();

  factory ComicReaderConfig.fromJson(Map<String, dynamic> json) =>
      _$ComicReaderConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ComicReaderConfigToJson(this);
}

@JsonSerializable()
class NovelReaderConfig extends ReaderConfig {
  const NovelReaderConfig() : super();

  factory NovelReaderConfig.fromJson(Map<String, dynamic> json) =>
      _$NovelReaderConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NovelReaderConfigToJson(this);
}
