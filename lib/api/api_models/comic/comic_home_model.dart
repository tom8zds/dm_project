import 'dart:convert';

import 'comic_state_model.dart';

List<RecommendList> recommendListFromMap(String str) =>
    List<RecommendList>.from(
        json.decode(str).map((x) => RecommendList.fromMap(x)));

String recommendListToMap(List<RecommendList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

BatchUpdate batchUpdateFromMap(String str) =>
    BatchUpdate.fromMap(json.decode(str));

String batchUpdateToMap(BatchUpdate data) => json.encode(data.toMap());

class BatchUpdate {
  BatchUpdate({
    this.code,
    this.msg,
    this.data,
  });

  final int? code;
  final String? msg;
  final RecommendList? data;

  factory BatchUpdate.fromMap(Map<String, dynamic> json) => BatchUpdate(
        code: json["code"],
        msg: json["msg"],
        data: RecommendList.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "msg": msg,
        "data": data!.toMap(),
      };
}

class RecommendList {
  RecommendList({
    this.categoryId,
    this.title,
    this.sort,
    this.data,
  });

  final int? categoryId;
  final String? title;
  final int? sort;
  final List<RecommendListItem>? data;

  factory RecommendList.fromMap(Map<String, dynamic> json) => RecommendList(
        categoryId: json["category_id"],
        title: json["title"],
        sort: json["sort"],
        data: List<RecommendListItem>.from(
            json["data"].map((x) => RecommendListItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId,
        "title": title,
        "sort": sort,
        "data": List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class RecommendListItem {
  RecommendListItem({
    this.cover,
    this.title,
    this.subTitle,
    this.type,
    this.url,
    this.objId,
    this.status,
    this.isDot,
    this.id,
    this.authors,
  });

  final String? cover;
  final String? title;
  final String? subTitle;
  final int? type;
  final String? url;
  final int? objId;
  final Status? status;
  final String? isDot;
  final int? id;
  final String? authors;

  factory RecommendListItem.fromMap(Map<String, dynamic> json) =>
      RecommendListItem(
        cover: json["cover"].replaceFirst('http:', 'https:'),
        title: json["title"],
        subTitle: json["sub_title"],
        type: json["type"],
        url: json["url"],
        objId: json["obj_id"],
        status: statusValues.map[json["status"]],
        isDot: json["is_dot"],
        id: json["id"],
        authors: json["authors"],
      );

  Map<String, dynamic> toMap() => {
        "cover": cover,
        "title": title,
        "sub_title": subTitle,
        "type": type,
        "url": url,
        "obj_id": objId,
        "status": statusValues.reverse[status ?? "未知"],
        "is_dot": isDot,
        "id": id,
        "authors": authors,
      };
}
