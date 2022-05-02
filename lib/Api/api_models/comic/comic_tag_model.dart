import 'dart:convert';

List<FilterTag> filterTagFromMap(String str) =>
    List<FilterTag>.from(json.decode(str).map((x) => FilterTag.fromMap(x)));

class FilterTag {
  FilterTag({
    this.tagId,
    this.tagName,
  });

  final int? tagId;
  final String? tagName;

  factory FilterTag.fromMap(Map<String, dynamic> json) => FilterTag(
        tagId: json["tag_id"],
        tagName: json["tag_name"],
      );

  Map<String, dynamic> toMap() => {
        "tag_id": tagId,
        "tag_name": tagName,
      };
}
