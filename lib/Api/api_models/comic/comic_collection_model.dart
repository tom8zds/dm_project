import 'dart:convert';

List<ComicCollection> comicCollectionFromMap(String str) =>
    List<ComicCollection>.from(
        json.decode(str).map((x) => ComicCollection.fromMap(x)));

String comicCollectionToMap(List<ComicCollection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ComicCollection {
  ComicCollection({
    this.id,
    this.title,
    this.shortTitle,
    this.createTime,
    this.smallCover,
    this.pageType,
    this.sort,
    this.pageUrl,
  });

  final int id;
  final String title;
  final String shortTitle;
  final int createTime;
  final String smallCover;
  final int pageType;
  final int sort;
  final String pageUrl;

  factory ComicCollection.fromMap(Map<String, dynamic> json) => ComicCollection(
        id: json["id"],
        title: json["title"],
        shortTitle: json["short_title"],
        createTime: json["create_time"],
        smallCover: json["small_cover"],
        pageType: json["page_type"],
        sort: json["sort"],
        pageUrl: json["page_url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "short_title": shortTitle,
        "create_time": createTime,
        "small_cover": smallCover,
        "page_type": pageType,
        "sort": sort,
        "page_url": pageUrl,
      };
}

ComicCollectionContent comicCollectionContentFromMap(String str) =>
    ComicCollectionContent.fromMap(json.decode(str));

String comicCollectionContentToMap(ComicCollectionContent data) =>
    json.encode(data.toMap());

class ComicCollectionContent {
  ComicCollectionContent({
    this.mobileHeaderPic,
    this.title,
    this.pageUrl,
    this.description,
    this.comics,
    this.commentAmount,
  });

  final String mobileHeaderPic;
  final String title;
  final String pageUrl;
  final String description;
  final List<CollectionItem> comics;
  final int commentAmount;

  factory ComicCollectionContent.fromMap(Map<String, dynamic> json) =>
      ComicCollectionContent(
        mobileHeaderPic: json["mobile_header_pic"],
        title: json["title"],
        pageUrl: json["page_url"],
        description: json["description"],
        comics: List<CollectionItem>.from(json["comics"].map((x) => CollectionItem.fromMap(x))),
        commentAmount: json["comment_amount"],
      );

  Map<String, dynamic> toMap() => {
        "mobile_header_pic": mobileHeaderPic,
        "title": title,
        "page_url": pageUrl,
        "description": description,
        "comics": List<dynamic>.from(comics.map((x) => x.toMap())),
        "comment_amount": commentAmount,
      };
}

class CollectionItem {
  CollectionItem({
    this.cover,
    this.recommendBrief,
    this.recommendReason,
    this.id,
    this.name,
    this.aliasName,
  });

  final String cover;
  final String recommendBrief;
  final String recommendReason;
  final int id;
  final String name;
  final String aliasName;

  factory CollectionItem.fromMap(Map<String, dynamic> json) => CollectionItem(
        cover: json["cover"],
        recommendBrief: json["recommend_brief"],
        recommendReason: json["recommend_reason"],
        id: json["id"],
        name: json["name"],
        aliasName: json["alias_name"],
      );

  Map<String, dynamic> toMap() => {
        "cover": cover,
        "recommend_brief": recommendBrief,
        "recommend_reason": recommendReason,
        "id": id,
        "name": name,
        "alias_name": aliasName,
      };
}
