// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj_radio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDjRadio _$MusicDjRadioFromJson(Map<String, dynamic> json) {
  return MusicDjRadio(
    json['id'] as int? ?? 0,
    json['subCount'] as int? ?? 0,
    json['programCount'] as int? ?? 0,
    json['createTime'] as int? ?? 0,
    json['categoryId'] as int? ?? 0,
    json['radioFeeType'] as int? ?? 0,
    json['playCount'] as int? ?? 0,
    json['shareCount'] as int? ?? 0,
    json['likedCount'] as int? ?? 0,
    json['commentCount'] as int? ?? 0,
  )
    ..dj = json['dj'] == null
        ? null
        : MusicDj.fromJson(json['dj'] as Map<String, dynamic>)
    ..name = json['name'] as String?
    ..rcmdText = json['rcmdText'] as String?
    ..lastProgramName = json['lastProgramName'] as String?
    ..picUrl = json['picUrl'] as String?
    ..desc = json['desc'] as String?
    ..category = json['category'] as String?;
}

Map<String, dynamic> _$MusicDjRadioToJson(MusicDjRadio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dj': instance.dj,
      'name': instance.name,
      'rcmdText': instance.rcmdText,
      'lastProgramName': instance.lastProgramName,
      'picUrl': instance.picUrl,
      'desc': instance.desc,
      'subCount': instance.subCount,
      'programCount': instance.programCount,
      'createTime': instance.createTime,
      'categoryId': instance.categoryId,
      'category': instance.category,
      'radioFeeType': instance.radioFeeType,
      'playCount': instance.playCount,
      'shareCount': instance.shareCount,
      'likedCount': instance.likedCount,
      'commentCount': instance.commentCount,
    };
