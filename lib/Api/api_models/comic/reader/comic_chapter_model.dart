import 'package:json_annotation/json_annotation.dart';

part 'comic_chapter_model.g.dart';

@JsonSerializable()
class ComicChapterData {
  const ComicChapterData({
    required this.chapterId,
    required this.comicId,
    required this.title,
    required this.chapterOrder,
    required this.direction,
    required this.pageUrl,
    required this.picNum,
    required this.commentCount,
  });

  static const empty = ComicChapterData(
      chapterId: 0,
      comicId: 0,
      title: "",
      chapterOrder: 0,
      direction: 0,
      pageUrl: [],
      picNum: 0,
      commentCount: 0);

  @JsonKey(name: "id")
  @JsonKey(name: "chapter_id")
  final int chapterId;
  @JsonKey(name: "comic_id")
  final int comicId;
  @JsonKey(name: "title")
  @JsonKey(name: "chapter_name")
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

  ComicChapterData copyWith({
    int? chapterId,
    int? comicId,
    String? title,
    int? chapterOrder,
    int? direction,
    List<String>? pageUrl,
    int? picNum,
    int? commentCount,
  }) =>
      ComicChapterData(
        chapterId: chapterId ?? this.chapterId,
        comicId: comicId ?? this.comicId,
        title: title ?? this.title,
        chapterOrder: chapterOrder ?? this.chapterOrder,
        direction: direction ?? this.direction,
        pageUrl: pageUrl ?? this.pageUrl,
        picNum: picNum ?? this.picNum,
        commentCount: commentCount ?? this.commentCount,
      );

  factory ComicChapterData.fromJson(Map<String, dynamic> json) =>
      _$ComicChapterDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComicChapterDataToJson(this);
}
