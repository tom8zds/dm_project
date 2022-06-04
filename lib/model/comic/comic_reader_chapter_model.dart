import 'package:dmapicore/api/api_models/comic/reader/comic_chapter_model.dart';
import 'package:equatable/equatable.dart';

class ComicReaderChapter extends Equatable{

  final ComicChapterData data;
  final bool isLocal;

  const ComicReaderChapter({required this.data, required this.isLocal});

  static const empty = ComicReaderChapter(data: ComicChapterData.empty, isLocal: false);

  @override
  List<Object?> get props => [data, isLocal];

}