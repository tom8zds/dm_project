// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalChapterAdapter extends TypeAdapter<LocalChapter> {
  @override
  final int typeId = 0;

  @override
  LocalChapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalChapter(
      chapterId: fields[0] as int,
      chapterTitle: fields[1] as String,
      order: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalChapter obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.chapterId)
      ..writeByte(1)
      ..write(obj.chapterTitle)
      ..writeByte(2)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalComicAdapter extends TypeAdapter<LocalComic> {
  @override
  final int typeId = 1;

  @override
  LocalComic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalComic(
      comicId: fields[0] as int,
      comicTitle: fields[1] as String,
      cover: fields[2] as String,
      chapters: (fields[3] as List).cast<LocalChapter>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocalComic obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.comicId)
      ..writeByte(1)
      ..write(obj.comicTitle)
      ..writeByte(2)
      ..write(obj.cover)
      ..writeByte(3)
      ..write(obj.chapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalComicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
