import 'dart:convert';

List<FilterTag> filterTagFromMap(String str) =>
    List<FilterTag>.from(json.decode(str).map((x) => FilterTag.fromMap(x)));

String filterTagToMap(List<FilterTag> tags) =>
    json.encode(List<dynamic>.from(tags.map((x) => x.toMap())));

class FilterTag {
  FilterTag({
    this.tagId = 0,
    this.tagName = "",
  });

  final int tagId;
  final String tagName;

  factory FilterTag.fromMap(Map<String, dynamic> json) => FilterTag(
        tagId: json["tag_id"],
        tagName: json["tag_name"],
      );

  Map<String, dynamic> toMap() => {
        "tag_id": tagId,
        "tag_name": tagName,
      };
}
