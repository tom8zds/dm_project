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

  final String title;
  final List<FilterTag> items;

  factory ComicCategoryFilter.fromMap(Map<String, dynamic> json) =>
      ComicCategoryFilter(
        title: json["title"],
        items: List<FilterTag>.from(
            json["items"].map((x) => FilterTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

List<ComicCategoryItem> comicCategoryItemFromMap(String str) =>
    List<ComicCategoryItem>.from(
        json.decode(str).map((x) => ComicCategoryItem.fromMap(x)));

String comicCategoryItemToMap(List<ComicCategoryItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ComicCategoryItem {
  ComicCategoryItem({
    this.id,
    this.title,
    this.authors,
    this.status,
    this.cover,
    this.types,
    this.lastUpdatetime,
    this.num,
  });

  final int id;
  final String title;
  final String authors;
  final Status status;
  final String cover;
  final String types;
  final int lastUpdatetime;
  final int num;

  factory ComicCategoryItem.fromMap(Map<String, dynamic> json) =>
      ComicCategoryItem(
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
        "status": statusValues.reverse[status],
        "cover": cover,
        "types": types,
        "last_updatetime": lastUpdatetime,
        "num": num,
      };
}
