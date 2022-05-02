import 'dart:convert';

import 'comic_state_model.dart';
import 'comic_tag_model.dart';

List<ComicCategoryFilter> comicCategoryFilterFromMap(String str) =>
    List<ComicCategoryFilter>.from(
        json.decode(str).map((x) => ComicCategoryFilter.fromMap(x)));

String comicCategoryFilterToMap(List<ComicCategoryFilter> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ComicCategoryFilter {
  ComicCategoryFilter({
     this.title,
     this.items,
  });

  final String? title;
  final List<FilterTag>? items;

  factory ComicCategoryFilter.fromMap(Map<String, dynamic> json) =>
      ComicCategoryFilter(
        title: json["title"],
        items: List<FilterTag>.from(
            json["items"].map((x) => FilterTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "items": List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}

List<ComicCategoryDetailItem> comicCategoryDetailItemFromMap(String str) =>
    List<ComicCategoryDetailItem>.from(
        json.decode(str).map((x) => ComicCategoryDetailItem.fromMap(x)));

String comicCategoryDetailItemToMap(List<ComicCategoryDetailItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ComicCategoryDetailItem {
  ComicCategoryDetailItem({
     this.id,
     this.title,
     this.authors,
     this.status,
     this.cover,
     this.types,
     this.lastUpdatetime,
     this.num,
  });

  final int? id;
  final String? title;
  final String? authors;
  final Status? status;
  final String? cover;
  final String? types;
  final int? lastUpdatetime;
  final int? num;

  factory ComicCategoryDetailItem.fromMap(Map<String, dynamic> json) =>
      ComicCategoryDetailItem(
        id: json["id"],
        title: json["title"],
        authors: json["authors"],
        status: statusValues.map[json["status"]],
        cover: json["cover"],
        types: json["types"],
        lastUpdatetime: json["last_updatetime"],
        num: json["num"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "authors": authors,
        "status": statusValues.reverse[status??"未知"],
        "cover": cover,
        "types": types,
        "last_updatetime": lastUpdatetime,
        "num": num,
      };
}

ComicCategoryList comicCategoryListFromMap(String str) => ComicCategoryList.fromMap(json.decode(str));

String comicCategoryListToMap(ComicCategoryList data) => json.encode(data.toMap());

class ComicCategoryList {
  ComicCategoryList({
    this.code,
    this.msg,
    this.data,
  });

  final int? code;
  final String? msg;
  final List<ComicCategoryItem>? data;

  factory ComicCategoryList.fromMap(Map<String, dynamic> json) => ComicCategoryList(
    code: json["code"],
    msg: json["msg"],
    data: List<ComicCategoryItem>.from(json["data"].map((x) => ComicCategoryItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class ComicCategoryItem {
  ComicCategoryItem({
    this.tagId,
    this.title,
    this.cover,
  });

  final int? tagId;
  final String? title;
  final String? cover;

  factory ComicCategoryItem.fromMap(Map<String, dynamic> json) => ComicCategoryItem(
    tagId: json["tag_id"],
    title: json["title"],
    cover: json["cover"],
  );

  Map<String, dynamic> toMap() => {
    "tag_id": tagId,
    "title": title,
    "cover": cover,
  };
}

