// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chunk_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MissionInfoAdapter extends TypeAdapter<MissionInfo> {
  @override
  final int typeId = 1;

  @override
  MissionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MissionInfo(
      url: fields[0] as String,
      savePath: fields[1] as String,
      chunkList: (fields[5] as List).cast<ChunkInfo>(),
      total: fields[4] as int,
      state: fields[2] as int,
    )..progress = fields[3] as int;
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
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.total)
      ..writeByte(5)
      ..write(obj.chunkList);
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

class ChunkInfoAdapter extends TypeAdapter<ChunkInfo> {
  @override
  final int typeId = 2;

  @override
  ChunkInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChunkInfo(
      url: fields[0] as String,
      start: fields[1] as int,
      end: fields[2] as int,
      order: fields[3] as int,
      state: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChunkInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChunkInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
