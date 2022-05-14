import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'comic_viewpoint_model.g.dart';

List<ComicViewPointData> comicViewPointFromJson(String str) => List<ComicViewPointData>.from(json.decode(str).map((x) => ComicViewPointData.fromJson(x)));

String comicViewPointToJson(List<ComicViewPointData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ComicViewPointData{
  ComicViewPointData({
    required this.id,
    required this.uid,
    required this.content,
    required this.num,
    required this.page,
  });

  final int id;
  final int uid;
  final String content;
  final int num;
  final int page;

  factory ComicViewPointData.fromJson(Map<String,dynamic> json) => _$ComicViewPointDataFromJson(json);

  Map<String,dynamic> toJson() => _$ComicViewPointDataToJson(this);

}