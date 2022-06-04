part of 'local_comic_cubit.dart';

class LocalComicState extends Equatable {
  final List<LocalComic> comicList;
  final LoadStatus status;

  @override
  List<Object?> get props => [comicList, status];

  static LocalComicState get empty =>
      const LocalComicState(comicList: [], status: LoadStatus.initial);

  const LocalComicState({
    required this.comicList,
    required this.status,
  });

  LocalComicState copyWith({
    List<LocalComic>? comicList,
    LoadStatus? status,
  }) {
    return LocalComicState(
      comicList: comicList ?? this.comicList,
      status: status ?? this.status,
    );
  }
}
