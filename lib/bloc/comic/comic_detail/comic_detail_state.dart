part of '../../../bloc/comic/comic_detail/comic_detail_cubit.dart';

class ComicDetailState extends Equatable {
  late final ComicDetail detail;
  late final LoadStatus status;
  late final List<bool> showSequence;

  ComicDetailState(
      {this.status = LoadStatus.initial,
      ComicDetail? detail,
      List<bool>? showSequence}) {
    this.detail = detail ?? ComicDetail.empty;
    if (detail == null || showSequence == null) {
      this.showSequence = List.empty();
    } else {
      if (showSequence.isNotEmpty) {
        this.showSequence = showSequence;
      } else {
        this.showSequence = List.filled(detail.volumes.length, false);
      }
    }
  }

  ComicDetailState copyWith(
      {LoadStatus? status, ComicDetail? detail, List<bool>? showSequence}) {
    return ComicDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      showSequence: showSequence ?? this.showSequence,
    );
  }

  @override
  List<Object?> get props => [status, detail, showSequence];
}
