// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_download_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MissionBindInfoAdapter extends TypeAdapter<MissionBindInfo> {
  @override
  final int typeId = 4;

  @override
  MissionBindInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MissionBindInfo(
      comicId: fields[0] as int,
      comicTitle: fields[1] as String,
      cover: fields[2] as String,
      chapterId: fields[3] as int,
      chapterTitle: fields[4] as String,
      order: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MissionBindInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.comicId)
      ..writeByte(1)
      ..write(obj.comicTitle)
      ..writeByte(2)
      ..write(obj.cover)
      ..writeByte(3)
      ..write(obj.chapterId)
      ..writeByte(4)
      ..write(obj.chapterTitle)
      ..writeByte(5)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionBindInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MissionInfoAdapter extends TypeAdapter<MissionInfo> {
  @override
  final int typeId = 3;

  @override
  MissionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MissionInfo(
      url: fields[0] as String,
      savePath: fields[1] as String,
      info: fields[2] as MissionBindInfo,
      progress: fields[5] as int,
      total: fields[6] as int,
      state: fields[4] as MissionState,
    );
  }

  @override
  void write(BinaryWriter writer, MissionInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.savePath)
      ..writeByte(2)
      ..write(obj.info)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.progress)
      ..writeByte(6)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MissionStateAdapter extends TypeAdapter<MissionState> {
  @override
  final int typeId = 2;

  @override
  MissionState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MissionState.waiting;
      case 1:
        return MissionState.downloading;
      case 2:
        return MissionState.pause;
      case 4:
        return MissionState.extracting;
      default:
        return MissionState.waiting;
    }
  }

  @override
  void write(BinaryWriter writer, MissionState obj) {
    switch (obj) {
      case MissionState.waiting:
        writer.writeByte(0);
        break;
      case MissionState.downloading:
        writer.writeByte(1);
        break;
      case MissionState.pause:
        writer.writeByte(2);
        break;
      case MissionState.extracting:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
