import 'package:dmapicore/api/api_models/comic/comic_tag_model.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:equatable/equatable.dart';

import 'comic_local_model.dart';

part 'comic_volume_model.dart';

part 'comic_chapter_model.dart';

class ComicDetail extends Equatable {
  final int comicId;
  final String comicTitle;
  final String cover;
  final String description;
  final String firstLetter;
  final List<FilterTag> authors;
  final List<FilterTag> tags;
  final List<FilterTag> status;
  final int hotNum;
  final int hitNum;
  final int subscribeNum;
  final int lastUpdateTime;
  final int lastUpdateChapterId;
  final String lastUpdateChapterName;

  final List<ComicVolume> volumes;

  static ComicDetail get empty =>
      const ComicDetail(
        comicId: 0,
        comicTitle: "",
        cover: "",
        authors: [],
        tags: [],
        status: [],
        description: "",
        firstLetter: "",
        hotNum: 0,
        hitNum: 0,
        subscribeNum: 0,
        lastUpdateTime: 0,
        lastUpdateChapterId: 0,
        lastUpdateChapterName: "",
        volumes: [],
      );

  Map<String, dynamic> toMap() {
    return {
      'comicId': comicId,
      'comicTitle': comicTitle,
      'cover': cover,
      'description': description,
      'firstLetter': firstLetter,
      'authors': filterTagToMap(authors),
      'tags': filterTagToMap(tags),
      'status': filterTagToMap(status),
      'hotNum': hotNum,
      'hitNum': hitNum,
      'subscribeNum': subscribeNum,
      'lastUpdateTime': lastUpdateTime,
      'lastUpdateChapterId': lastUpdateChapterId,
      'lastUpdateChapterName': lastUpdateChapterName,
      'volumes': volumes,
    };
  }

  factory ComicDetail.fromMap(Map<String, dynamic> map) {
    return ComicDetail(
      comicId: map['comicId'] as int,
      comicTitle: map['comicTitle'] as String,
      cover: map['cover'] as String,
      description: map['description'],
      firstLetter: map['firstLetter'],
      authors: filterTagFromMap(map['authors']),
      tags: filterTagFromMap(map['tags']),
      hotNum: map['hotNum'] as int,
      hitNum: map['hitNum'] as int,
      subscribeNum: map['subscribeNum'] as int,
      lastUpdateTime: map['lastUpdateTime'] as int,
      lastUpdateChapterId: map['lastUpdateChapterId'] as int,
      lastUpdateChapterName: map['lastUpdateChapterName'] as String,
      volumes: map['volumes'] as List<ComicVolume>,
      status: filterTagFromMap(map['status']),
    );
  }

  factory ComicDetail.fromRemoteDetail(ComicDetailInfoResponse detail) {
    return ComicDetail(
      comicId: detail.id,
      comicTitle: detail.title,
      cover: detail.cover,
      description: detail.description,
      firstLetter: detail.firstLetter,
      authors: detail.authors.map((e) =>
          FilterTag(tagId: e.tagId, tagName: e.tagName)).toList(),
      tags: detail.types.map((e) =>
          FilterTag(tagId: e.tagId, tagName: e.tagName)).toList(),
      status: detail.status.map((e) =>
          FilterTag(tagId: e.tagId, tagName: e.tagName)).toList(),
      hotNum: detail.hotNum,
      hitNum: detail.hitNum,
      subscribeNum: detail.subscribeNum,
      lastUpdateChapterId: detail.lastUpdateChapterId,
      lastUpdateChapterName: detail.lastUpdateChapterName,
      lastUpdateTime: detail.lastUpdatetime.toInt(),
      volumes: detail.chapters
          .map((e) =>
          ComicVolume(
              comicId: detail.id,
              comicTitle: detail.title,
              volumeTitle: e.title,
              chapterList:
              e.data.map((e) => ComicChapter.fromRemoteChapter(e)).toList(),
              firstLetter: detail.firstLetter))
          .toList(),
    );
  }

  const ComicDetail({
    required this.comicId,
    required this.comicTitle,
    required this.cover,
    required this.description,
    required this.firstLetter,
    required this.authors,
    required this.tags,
    required this.status,
    required this.hotNum,
    required this.hitNum,
    required this.subscribeNum,
    required this.lastUpdateTime,
    required this.lastUpdateChapterId,
    required this.lastUpdateChapterName,
    required this.volumes,
  });

  ComicDetail copyWith({
    int? comicId,
    String? comicTitle,
    String? cover,
    String? description,
    String? firstLetter,
    List<FilterTag>? authors,
    List<FilterTag>? tags,
    List<FilterTag>? status,
    int? hotNum,
    int? hitNum,
    int? subscribeNum,
    int? lastUpdateTime,
    int? lastUpdateChapterId,
    String? lastUpdateChapterName,
    List<ComicVolume>? volumes,
  }) {
    return ComicDetail(
      comicId: comicId ?? this.comicId,
      comicTitle: comicTitle ?? this.comicTitle,
      cover: cover ?? this.cover,
      description: description ?? this.description,
      firstLetter: firstLetter ?? this.firstLetter,
      authors: authors ?? this.authors,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      hotNum: hotNum ?? this.hotNum,
      hitNum: hitNum ?? this.hitNum,
      subscribeNum: subscribeNum ?? this.subscribeNum,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      lastUpdateChapterId: lastUpdateChapterId ?? this.lastUpdateChapterId,
      lastUpdateChapterName:
      lastUpdateChapterName ?? this.lastUpdateChapterName,
      volumes: volumes ?? this.volumes,
    );
  }

  @override
  List<Object> get props =>
      [
        comicId,
        comicTitle,
        cover,
        description,
        firstLetter,
        authors,
        tags,
        status,
        hotNum,
        hitNum,
        subscribeNum,
        lastUpdateTime,
        lastUpdateChapterId,
        lastUpdateChapterName,
        volumes,
      ];
}
