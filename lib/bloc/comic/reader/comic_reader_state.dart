part of 'comic_reader_cubit.dart';

class ComicReaderState extends Equatable {
  final ComicVolume volume;
  final ComicReaderChapter chapter;
  final LoadStatus status;
  final double progress;

  const ComicReaderState(
      {this.volume = ComicVolume.emtpy,
      this.status = LoadStatus.initial,
      this.chapter = ComicReaderChapter.empty,
      this.progress = 0});

  int get page => progress.round();

  ComicReaderState copyWith(
      {ComicVolume? volume,
        ComicReaderChapter? chapter,
      LoadStatus? status,
      double? progress}) {
    return ComicReaderState(
        volume: volume ?? this.volume,
        chapter: chapter ?? this.chapter,
        status: status ?? this.status,
        progress: progress ?? this.progress);
  }

  @override
  List<Object> get props => [volume, chapter, status, progress];
}
