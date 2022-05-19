part of 'comic_reader_cubit.dart';

class ComicReaderState extends Equatable {
  final ComicVolume volume;
  final ComicChapter chapter;
  final LoadStatus status;
  final int progress;

  const ComicReaderState(
      {this.volume = ComicVolume.emtpy,
      this.status = LoadStatus.initial,
      this.chapter = ComicChapter.empty,
      this.progress = 0});

  ComicReaderState copyWith(
      {ComicVolume? volume,
      ComicChapter? chapter,
      LoadStatus? status,
      int? progress}) {
    return ComicReaderState(
        volume: volume ?? this.volume,
        chapter: chapter ?? this.chapter,
        status: status ?? this.status,
        progress: progress ?? this.progress);
  }

  @override
  List<Object> get props => [volume, chapter, status, progress];
}
