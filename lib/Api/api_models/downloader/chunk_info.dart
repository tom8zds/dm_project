import 'package:hive/hive.dart';

part 'chunk_info.g.dart';

@HiveType(typeId: 1)
class MissionInfo {
  @HiveField(0)
  String url;
  @HiveField(1)
  String savePath;
  @HiveField(2)
  int state = 0;
  @HiveField(3)
  int progress = 0;
  @HiveField(4)
  int total;
  @HiveField(5)
  List<ChunkInfo> chunkList;

  MissionInfo(
      {required this.url,
      required this.savePath,
      required this.chunkList,
      this.total = 1,
      this.state = 0});
}

@HiveType(typeId: 2)
class ChunkInfo extends HiveObject {
  @HiveField(0)
  String url;
  @HiveField(1)
  int start;
  @HiveField(2)
  int end;
  @HiveField(3)
  int order;
  @HiveField(4)
  int state;

  ChunkInfo(
      {required this.url,
      required this.start,
      required this.end,
      required this.order,
      this.state = 0});
}
