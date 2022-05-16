part of 'comic_reader_cubit.dart';

class ComicReaderState extends Equatable {
  final ComicVolume volume;
  final ComicChapter chapter;
  final LoadStatus status;

  const ComicReaderState(
      {this.volume = ComicVolume.emtpy,
      this.status = LoadStatus.initial,
      this.chapter = ComicChapter.empty});

  ComicReaderState copyWith(
      {ComicVolume? volume, ComicChapter? chapter, LoadStatus? status}) {
    return ComicReaderState(
        volume: volume ?? this.volume,
        chapter: chapter ?? this.chapter,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [volume, chapter, status];
}
