import 'package:bloc/bloc.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:dmapicore/model/comic/comic_volume_model.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/repo/comic/comic_chapter_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:preload_page_view/preload_page_view.dart';

part 'comic_reader_state.dart';

class ComicReaderCubit extends Cubit<ComicReaderState> {
  ComicReaderCubit(ComicVolume volume)
      : super(ComicReaderState(volume: volume));

  final repo = ComicChapterRepo();
  final PreloadPageController pageController = PreloadPageController();

  void movePage(int page) {
    if (page < 0 ||
        page > state.chapter.data.picNum - 1 ||
        page == state.progress) {
      return;
    }
    pageController.jumpToPage(page);
    emit(state.copyWith(progress: page));
  }

  void nextPage() {
    final page = state.progress + 1;
    if (page < 0 || page > state.chapter.data.picNum - 1) {
      return;
    }
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    emit(state.copyWith(progress: page));
  }

  void lastPage() {
    final page = state.progress - 1;
    if (page < 0 || page > state.chapter.data.picNum - 1) {
      return;
    }
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    emit(state.copyWith(progress: page));
  }

  void onPageChange(int? page) {
    if (page == null || page < 0 || page > state.chapter.data.picNum) {
      return;
    }
    emit(state.copyWith(progress: page));
  }

  @override
  Future<void> close() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.close();
  }

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
