import 'package:json_annotation/json_annotation.dart';

ComicChapterData _$ComicChapterDataFromJson(Map<String, dynamic> json) =>
    ComicChapterData(
      chapterId: (json['chapter_id'] ?? json['id']) as int,
      comicId: json['comic_id'] as int,
      title: json['title'] ?? json['chapter_name'] as String,
      chapterOrder: json['chapter_order'] as int,
      direction: json['direction'] as int,
      pageUrl:
      (json['page_url'] as List<dynamic>).map((e) => e as String).toList(),
      picNum: json['picnum'] as int,
      commentCount: json['comment_count'] as int,
    );

Map<String, dynamic> _$ComicChapterDataToJson(ComicChapterData instance) =>
    <String, dynamic>{
      'chapter_id': instance.chapterId,
      'comic_id': instance.comicId,
      'title': instance.title,
      'chapter_order': instance.chapterOrder,
      'direction': instance.direction,
      'page_url': instance.pageUrl,
      'picnum': instance.picNum,
      'comment_count': instance.commentCount,
    };

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

  final int chapterId;
  final int comicId;
  final String title;
  final int chapterOrder;
  final int direction;
  final List<String> pageUrl;
  final int picNum;
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
