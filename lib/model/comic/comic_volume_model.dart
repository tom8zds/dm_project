part of 'comic_detail_model.dart';

class ComicVolume extends Equatable {
  final int comicId;
  final String comicTitle;
  final String volumeTitle;
  final String firstLetter;
  final List<ComicChapter> chapterList;

  const ComicVolume({
    required this.comicId,
    required this.comicTitle,
    required this.volumeTitle,
    required this.chapterList,
    required this.firstLetter,
  });

  static const emtpy = ComicVolume(
      comicId: 0,
      comicTitle: "",
      volumeTitle: "",
      chapterList: [],
      firstLetter: "");



  @override
  List<Object?> get props => [comicId, comicTitle, volumeTitle, chapterList];

  Map<String, dynamic> toMap() {
    return {
      'comicId': comicId,
      'comicTitle': comicTitle,
      'volumeTitle': volumeTitle,
      'firstLetter': firstLetter,
      'chapterList': chapterList,
    };
  }

  factory ComicVolume.fromMap(Map<String, dynamic> map) {
    return ComicVolume(
      comicId: map['comicId'] as int,
      comicTitle: map['comicTitle'] as String,
      volumeTitle: map['volumeTitle'] as String,
      firstLetter: map['firstLetter'] as String,
      chapterList: map['chapterList'] as List<ComicChapter>,
    );
  }
}
