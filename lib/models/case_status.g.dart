// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_status.dart';

// **************************************************************************
// JsonSerializableGenerator
//
CaseStatus _$CaseStatusFromJson(Map<String, dynamic> json) {
  return CaseStatus(
    address: json['address'] as String,
    circle: json['circle_name']  as String,
    contact: json['contact'] as String,
    father_name: json['father_name'] as String,
    mauza: json['mauza'] as String,
    name: json['name'] as String,
    panchayat: json['panchayat_name'] as String,
    vivad_reason: json['vivad_reason'] as String,
    vivad_type: json['vivad_type_name'] as String,
    case_status: json['case_status'] as String,
  );
}

Map<String, dynamic> _$CaseStatusToJson(CaseStatus instance) => <String, dynamic>{
  'address': instance.address,
  'circle': instance.circle,
  'contact': instance.contact,
  'father_name': instance.father_name,
  'mauza': instance.mauza,
  'name': instance.name,
  'panchayat': instance.panchayat,
  'vivad_reason': instance.vivad_reason,
  'vivad_type': instance.vivad_type,
  'case_status' : instance.case_status,
};