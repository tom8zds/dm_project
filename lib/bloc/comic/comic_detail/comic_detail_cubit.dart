import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:dmapicore/api/comic_api.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/comic/comic_detail_model.dart';
import 'package:dmapicore/model/comic/comic_local_model.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'comic_detail_state.dart';

class ComicDetailCubit extends Cubit<ComicDetailState> {
  ComicDetailCubit() : super(ComicDetailState());

  final Box localComicBox = Hive.box(localComicBoxKey);

  Future<void> fetchDetail(int?  comicId) async {
    if (comicId == null) return;

    emit(state.copyWith(status: LoadStatus.loading));

    try {
      final remoteDetail = (await ComicApi.instance.getDetail(comicId));
      final detail = ComicDetail.fromRemoteDetail(remoteDetail);
      if(localComicBox.containsKey(detail.comicId)){
        final LocalComic localComic = localComicBox.get(detail.comicId);
        for(LocalChapter chapter in localComic.chapters){
          for(ComicVolume volume in detail.volumes){
            final index = volume.chapterList.indexWhere((item) => item.chapterId == chapter.chapterId);
            if(index != -1){
              volume.chapterList[index] = ComicChapter.fromLocalChapter(chapter);
            }
          }
        }
      }
      final newState =
          state.copyWith(status: LoadStatus.success, detail: detail);
      emit(newState);
    } on Exception {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  void toggleShowSequence(int index) {
    if (!state.status.isSuccess) return;
    if (state.detail == ComicDetail.empty) return;
    final newsquc = state.showSequence.toList();
    newsquc[index] = !newsquc[index];
    emit(state.copyWith(showSequence: newsquc));
  }
}
