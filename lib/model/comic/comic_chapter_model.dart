part of 'comic_detail_model.dart';

class ComicChapter extends Equatable {
  final int chapterId;
  final String chapterTitle;
  final int order;
  final bool isLocal;

  const ComicChapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.order,
    required this.isLocal,
  });

  ComicChapter copyWith({
    int? chapterId,
    String? chapterTitle,
    int? order,
    bool? isLocal,
  }) {
    return ComicChapter(
      chapterId: chapterId ?? this.chapterId,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      order: order ?? this.order,
      isLocal: isLocal ?? this.isLocal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'order': order,
      'isLocal': isLocal,
    };
  }

  factory ComicChapter.fromMap(Map<String, dynamic> map) {
    return ComicChapter(
      chapterId: map['chapterId'] as int,
      chapterTitle: map['chapterTitle'] as String,
      order: map['order'] as int,
      isLocal: map['isLocal'] as bool,
    );
  }

  factory ComicChapter.fromLocalChapter(LocalChapter chapter) {
    return ComicChapter(
      chapterId: chapter.chapterId,
      chapterTitle: chapter.chapterTitle,
      order: chapter.order,
      isLocal: true,
    );
  }

  factory ComicChapter.fromRemoteChapter(ComicDetailChapterInfoResponse chapter) {
    return ComicChapter(
      chapterId: chapter.chapterId,
      chapterTitle: chapter.chapterTitle,
      order: chapter.chapterOrder,
      isLocal: false,
    );
  }

  @override
  List<Object> get props => [chapterId, chapterTitle, order, isLocal];
}