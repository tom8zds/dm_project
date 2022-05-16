part of "comic_volume_model.dart";

class ComicChapter extends Equatable{

  final ComicChapterData data;
  final bool isLocal;

  const ComicChapter({required this.data, required this.isLocal});

  static const empty = ComicChapter(data: ComicChapterData.empty, isLocal: false);

  @override
  List<Object?> get props => [data, isLocal];

}