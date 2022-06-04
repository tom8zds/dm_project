import 'package:dmapicore/internal/app_constants.dart';
import 'package:hive/hive.dart';

part 'comic_download_model.g.dart';

@HiveType(typeId: 2)
enum MissionState {
  @HiveField(0)
  waiting,
  @HiveField(1)
  downloading,
  @HiveField(2)
  pause,
  @HiveField(4)
  extracting
}

extension MissionStateX on MissionState{
  String getName(){
    switch(this){
      case MissionState.waiting:
        return "列队中";
      case MissionState.downloading:
        return "下载中";
      case MissionState.pause:
        return "暂停";
      case MissionState.extracting:
        return "解压中";
    }
  }
}

@HiveType(typeId: 4)
class MissionBindInfo{
  @HiveField(0)
  int comicId;
  @HiveField(1)
  String comicTitle;
  @HiveField(2)
  String cover;
  @HiveField(3)
  int chapterId;
  @HiveField(4)
  String chapterTitle;
  @HiveField(5)
  int order;

  MissionBindInfo({
    required this.comicId,
    required this.comicTitle,
    required this.cover,
    required this.chapterId,
    required this.chapterTitle,
    required this.order,
  });
}

@HiveType(typeId: 3)
class MissionInfo {
  @HiveField(0)
  String url;
  @HiveField(1)
  String savePath;
  @HiveField(2)
  MissionBindInfo info;
  @HiveField(4)
  MissionState state;
  @HiveField(5)
  int progress;
  @HiveField(6)
  int total;

  MissionInfo({
    required this.url,
    required this.savePath,
    required this.info,
    this.progress = 0,
    this.total = 0,
    this.state = MissionState.waiting,
  });

  MissionInfo copyWith({
    String? url,
    String? savePath,
    MissionBindInfo? info,
    MissionState? state,
    int? progress,
    int? total,
  }) {
    return MissionInfo(
      url: url ?? this.url,
      savePath: savePath ?? this.savePath,
      info: info ?? this.info,
      state: state ?? this.state,
      progress: progress ?? this.progress,
      total: total ?? this.total,
    );
  }
}
