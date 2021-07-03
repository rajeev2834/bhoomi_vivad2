// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mauza.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mauza _$MauzaFromJson(Map<String, dynamic> json) {
  return Mauza(
    circle_id: json['circle_id'] as String,
    mauza_id: json['mauza_id'] as int,
    mauza_name_hn: json['mauza_name_hn'] as String,
    panchayat_id: json['panchayat_id'] as String,
  );
}

Map<String, dynamic> _$MauzaToJson(Mauza instance) => <String, dynamic>{
      'circle_id': instance.circle_id,
      'mauza_id': instance.mauza_id,
      'mauza_name_hn': instance.mauza_name_hn,
      'panchayat_id': instance.panchayat_id,
    };
