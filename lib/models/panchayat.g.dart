// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchayat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Panchayat _$PanchayatFromJson(Map<String, dynamic> json) {
  return Panchayat(
    circle_id: json['circle'] as String,
    panchayat_id: json['id'] as int,
    panchayat_name: json['panchayat_name'] as String,
    panchayat_name_hn: json['panchayat_name_hn'] as String,
  );
}

Map<String, dynamic> _$PanchayatToJson(Panchayat instance) => <String, dynamic>{
      'circle_id': instance.circle_id,
      'panchayat_id': instance.panchayat_id,
      'panchayat_name': instance.panchayat_name,
      'panchayat_name_hn': instance.panchayat_name_hn,
    };
