import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comic_detail_state.dart';

part 'comic_detail_cubit.g.dart';

class ComicDetailCubit extends Cubit<ComicDetailState> {
  late final Box detailBox;

  ComicDetailCubit() : super(ComicDetailState()) {
    loadBox();
  }

  void loadBox() async {
    detailBox = await Hive.openBox("detailBox");
  }

  Future<void> fetchDetail(int? comicId) async {
    if (comicId == null) return;

    emit(state.copyWith(status: ComicDetailStatus.loading));

    try {
      final detail = (await ComicApi.instance.getDetail(comicId));
      final newState =
          state.copyWith(status: ComicDetailStatus.success, detail: detail);
      emit(newState);
      detailBox.put(comicId, newState.toJson());
    } on Exception {
      emit(state.copyWith(status: ComicDetailStatus.failure));
    }
  }

  Future<void> refreshDetail() async {
    if (!state.status.isSuccess) return;
    if (state.detail == ComicDetailResponse.getDefault()) return;
    try {
      final detail = (await ComicApi.instance.getDetail(state.detail.id));
      emit(state.copyWith(detail: detail));
    } on Exception {
      emit(state.copyWith(status: ComicDetailStatus.failure));
    }
  }

  void toggleShowSequence(int index) {
    if (!state.status.isSuccess) return;
    if (state.detail == ComicDetailResponse.getDefault()) return;
    final newsquc = state.showSequence.toList();
    newsquc[index] = !newsquc[index];
    emit(state.copyWith(showSequence: newsquc));
  }
}
