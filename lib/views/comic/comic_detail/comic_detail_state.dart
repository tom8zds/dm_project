part of 'comic_detail_cubit.dart';

enum ComicDetailStatus {
  @JsonValue("initial")
  initial,
  @JsonValue("loading")
  loading,
  @JsonValue("success")
  success,
  @JsonValue("failure")
  failure
}

extension ComicDetailStatusX on ComicDetailStatus {
  bool get isInitial => this == ComicDetailStatus.initial;

  bool get isLoading => this == ComicDetailStatus.loading;

  bool get isSuccess => this == ComicDetailStatus.success;

  bool get isFailure => this == ComicDetailStatus.failure;
}

class ComicDetailConverter
    implements JsonConverter<ComicDetailInfoResponse, String> {
  const ComicDetailConverter();

  @override
  ComicDetailInfoResponse fromJson(String json) {
    return ComicDetailInfoResponse.fromJson(json);
  }

  @override
  String toJson(ComicDetailInfoResponse object) {
    return object.writeToJson();
  }
}

@JsonSerializable()
class ComicDetailState extends Equatable {
  @JsonKey(name: "detail")
  @ComicDetailConverter()
  late final ComicDetailInfoResponse detail;
  late final ComicDetailStatus status;
  late final List<bool> showSequence;

  ComicDetailState(
      {this.status = ComicDetailStatus.initial,
      ComicDetailInfoResponse? detail,
      List<bool>? showSequence}) {
    this.detail = detail ?? ComicDetailInfoResponse.getDefault();
    if (detail == null || showSequence == null) {
      this.showSequence = List.empty();
    } else {
      if (showSequence.isNotEmpty) {
        this.showSequence = showSequence;
      }else{
        this.showSequence = List.filled(detail.chapters.length, false);
      }
    }
  }

  ComicDetailState copyWith(
      {ComicDetailStatus? status,
      ComicDetailInfoResponse? detail,
      List<bool>? showSequence}) {
    return ComicDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      showSequence: showSequence ?? this.showSequence,
    );
  }

  factory ComicDetailState.fromJson(Map<String, dynamic> json) =>
      _$ComicDetailStateFromJson(json);

  Map<String, dynamic> toJson() => _$ComicDetailStateToJson(this);

  @override
  List<Object?> get props => [status, detail, showSequence];
}
