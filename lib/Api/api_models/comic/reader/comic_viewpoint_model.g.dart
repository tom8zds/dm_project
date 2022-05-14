// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_viewpoint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicViewPointData _$ComicViewPointDataFromJson(Map<String, dynamic> json) =>
    ComicViewPointData(
      id: json['id'] as int,
      uid: json['uid'] as int,
      content: json['content'] as String,
      num: json['num'] as int,
      page: json['page'] as int,
    );

Map<String, dynamic> _$ComicViewPointDataToJson(ComicViewPointData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'content': instance.content,
      'num': instance.num,
      'page': instance.page,
    };
