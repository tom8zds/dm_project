import 'dart:convert';

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
  final List<Item> items;

  factory ComicCategoryFilter.fromMap(Map<String, dynamic> json) =>
      ComicCategoryFilter(
        title: json["title"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

class Item {
  Item({
    this.tagId,
    this.tagName,
  });

  final int tagId;
  final String tagName;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        tagId: json["tag_id"],
        tagName: json["tag_name"],
      );

  Map<String, dynamic> toMap() => {
        "tag_id": tagId,
        "tag_name": tagName,
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

enum Status { EMPTY, STATUS }

final statusValues = EnumValues({"连载中": Status.EMPTY, "已完结": Status.STATUS});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
