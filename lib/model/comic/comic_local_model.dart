import 'package:dmapicore/model/downloader/comic_download_model.dart';
import 'package:hive/hive.dart';

part 'comic_local_model.g.dart';

@HiveType(typeId: 0)
class LocalChapter{
  @HiveField(0)
  final int chapterId;
  @HiveField(1)
  final String chapterTitle;
  @HiveField(2)
  final int order;

  const LocalChapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.order,
  });
}

@HiveType(typeId: 1)
class LocalComic{
  @HiveField(0)
  final int comicId;
  @HiveField(1)
  final String comicTitle;
  @HiveField(2)
  final String cover;
  @HiveField(3)
  final List<LocalChapter> chapters;

  const LocalComic({
    required this.comicId,
    required this.comicTitle,
    required this.cover,
    required this.chapters,
  });
}