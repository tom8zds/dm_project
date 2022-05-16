import 'package:dmapicore/api/api_models/comic/reader/comic_chapter_model.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:equatable/equatable.dart';

part 'comic_chapter_model.dart';

class ComicVolume extends Equatable {
  final int comicId;
  final String comicTitle;
  final String volumeTitle;
  final String firstLetter;
  final List<ComicDetailChapterInfoResponse> chapterList;

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
}
