import 'package:dmapicore/api/http_util.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:hive/hive.dart';

import 'chunk_info.dart';

class MissionDao {
  final Box missionBox = Hive.box(comicMissionBoxKey);

  static MissionDao? _missionDao;

  static MissionDao get instance => _missionDao ??= MissionDao();

  Future<void> addMission(MissionInfo missionInfo) async {
    return missionBox.put(missionInfo.url, missionInfo);
  }

  Future<void> deleteMission(String key) async {
    return missionBox.delete(key);
  }

  Future<void> putMission(MissionInfo missionInfo) async {
    return missionBox.put(missionInfo.url, missionInfo);
  }

  Future<MissionInfo> getMission(String key) async {
    final data = missionBox.get(key);
    if(data == null){
      throw AppError("获取任务失败");
    }
    return data;
  }

  Future<List<MissionInfo>> getAllMission() async {
    return missionBox.values.cast<MissionInfo>().toList();
  }
}
