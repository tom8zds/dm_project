import 'package:json_annotation/json_annotation.dart';

part 'comic_chapter_model.g.dart';

@JsonSerializable()
class ComicChapterData {
  ComicChapterData({
    required this.chapterId,
    required this.comicId,
    required this.title,
    required this.chapterOrder,
    required this.direction,
    required this.pageUrl,
    required this.picNum,
    required this.commentCount,
  });

  @JsonKey(name: "chapter_id")
  final int chapterId;
  @JsonKey(name: "comic_id")
  final int comicId;
  final String title;
  @JsonKey(name: "chapter_order")
  final int chapterOrder;
  final int direction;
  @JsonKey(name: "page_url")
  final List<String> pageUrl;
  @JsonKey(name: "picnum")
  final int picNum;
  @JsonKey(name: "comment_count")
  final int commentCount;

  factory ComicChapterData.fromJson(Map<String, dynamic> json) =>
      _$ComicChapterDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComicChapterDataToJson(this);
}
