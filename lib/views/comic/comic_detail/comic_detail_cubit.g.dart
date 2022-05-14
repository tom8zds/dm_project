// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_detail_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicDetailState _$ComicDetailStateFromJson(Map<String, dynamic> json) =>
    ComicDetailState(
      status: $enumDecodeNullable(_$ComicDetailStatusEnumMap, json['status']) ??
          ComicDetailStatus.initial,
      detail: json['detail'] == null
          ? null
          : ComicDetailInfoResponse.fromJson(json['detail'] as String),
      showSequence: (json['showSequence'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
    );

Map<String, dynamic> _$ComicDetailStateToJson(ComicDetailState instance) =>
    <String, dynamic>{
      'detail': const ComicDetailConverter().toJson(instance.detail),
      'status': _$ComicDetailStatusEnumMap[instance.status],
      'showSequence': instance.showSequence,
    };

const _$ComicDetailStatusEnumMap = {
  ComicDetailStatus.initial: 'initial',
  ComicDetailStatus.loading: 'loading',
  ComicDetailStatus.success: 'success',
  ComicDetailStatus.failure: 'failure',
};
