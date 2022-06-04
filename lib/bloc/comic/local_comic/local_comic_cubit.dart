import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/model/comic/comic_local_model.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'local_comic_state.dart';

class LocalComicCubit extends Cubit<LocalComicState> {
  LocalComicCubit() : super(LocalComicState.empty);

  final Box localComicBox = Hive.box(localComicBoxKey);

  Future loadData() async {
    emit(state.copyWith(status: LoadStatus.loading));
    final List<LocalComic> comicList = localComicBox.values.toList().cast<LocalComic>();
    emit(state.copyWith(comicList: comicList, status: LoadStatus.success));
  }
}
