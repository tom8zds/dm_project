import 'package:bloc/bloc.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:dmapicore/model/comic/comic_volume_model.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/repo/comic/comic_chapter_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'comic_reader_state.dart';

class ComicReaderCubit extends Cubit<ComicReaderState> {
  ComicReaderCubit(ComicVolume volume)
      : super(ComicReaderState(volume: volume));

  final repo = ComicChapterRepo();

  Future<void> fetchChapterData(int index) async {
    if (state.volume == ComicVolume.emtpy) {
      return;
    }
    if (index < 0 || index >= state.volume.chapterList.length) {
      return;
    }
    final chapterInfo = state.volume.chapterList.elementAt(index);
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      ComicChapter chapter = await repo.getComicChapter(
          state.volume.firstLetter,
          state.volume.comicId,
          chapterInfo.chapterId);
      emit(state.copyWith(chapter: chapter, status: LoadStatus.success));
    } on Exception {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }
}
