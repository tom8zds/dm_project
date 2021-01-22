import 'dart:convert';

import 'comic_state_model.dart';

List<ComicRankItem> comicRankItemFromMap(String str) =>
    List<ComicRankItem>.from(
        json.decode(str).map((x) => ComicRankItem.fromMap(x)));

String comicRankItemToMap(List<ComicRankItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ComicRankItem {
  ComicRankItem({
    this.comicId,
    this.title,
    this.authors,
    this.status,
    this.cover,
    this.types,
    this.lastUpdatetime,
    this.lastUpdateChapterName,
    this.comicPy,
    this.num,
    this.tagId,
  });

  final String comicId;
  final String title;
  final String authors;
  final Status status;
  final String cover;
  final String types;
  final String lastUpdatetime;
  final String lastUpdateChapterName;
  final String comicPy;
  final String num;
  final String tagId;

  factory ComicRankItem.fromMap(Map<String, dynamic> json) => ComicRankItem(
        comicId: json["comic_id"],
        title: json["title"],
        authors: json["authors"],
        status: statusValues.map[json["status"]],
        cover: json["cover"],
        types: json["types"],
        lastUpdatetime: json["last_updatetime"],
        lastUpdateChapterName: json["last_update_chapter_name"],
        comicPy: json["comic_py"],
        num: json["num"],
        tagId: json["tag_id"],
      );

  Map<String, dynamic> toMap() => {
        "comic_id": comicId,
        "title": title,
        "authors": authors,
        "status": statusValues.reverse[status],
        "cover": cover,
        "types": types,
        "last_updatetime": lastUpdatetime,
        "last_update_chapter_name": lastUpdateChapterName,
        "comic_py": comicPy,
        "num": num,
        "tag_id": tagId,
      };
}
