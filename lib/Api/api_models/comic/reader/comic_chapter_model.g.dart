// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicChapterData _$ComicChapterDataFromJson(Map<String, dynamic> json) =>
    ComicChapterData(
      chapterId: (json['chapter_id'] ?? json['id']) as int,
      comicId: json['comic_id'] as int,
      title: (json['title'] ?? json['chapter_name']) as String,
      chapterOrder: json['chapter_order'] as int,
      direction: json['direction'] as int,
      pageUrl:
          (json['page_url'] as List<dynamic>).map((e) => e as String).toList(),
      picNum: json['picnum'] as int,
      commentCount: (json['comment_count'] ?? 0) as int,
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
