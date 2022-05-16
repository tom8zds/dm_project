// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_detail_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicDetailState _$ComicDetailStateFromJson(Map<String, dynamic> json) =>
    ComicDetailState(
      status: $enumDecodeNullable(_$LoadStatusEnumMap, json['status']) ??
          LoadStatus.initial,
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
      'status': _$LoadStatusEnumMap[instance.status],
      'showSequence': instance.showSequence,
    };

const _$LoadStatusEnumMap = {
  LoadStatus.initial: 'initial',
  LoadStatus.loading: 'loading',
  LoadStatus.success: 'success',
  LoadStatus.failure: 'failure',
};
