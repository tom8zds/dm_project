import 'package:json_annotation/json_annotation.dart';

enum LoadStatus {
  @JsonValue("initial")
  initial,
  @JsonValue("loading")
  loading,
  @JsonValue("success")
  success,
  @JsonValue("failure")
  failure
}

extension LoadStatusX on LoadStatus {
  bool get isInitial => this == LoadStatus.initial;

  bool get isLoading => this == LoadStatus.loading;

  bool get isSuccess => this == LoadStatus.success;

  bool get isFailure => this == LoadStatus.failure;
}
