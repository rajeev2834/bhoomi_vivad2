// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hearing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hearing _$HearingFromJson(Map<String, dynamic> json) {
  return Hearing(
    id: json['id'] as int,
    grievance_id: json['grievance_id'] as String,
    next_hearing_date: json['next_hearing_date'] as String,
    remarks: json['remarks'] as String,
    case_status: json['case_status'] as String,
    created_at: json['created_at'] as String,
  );
}

Map<String, dynamic> _$HearingToJson(Hearing instance) => <String, dynamic>{
      'grievance_id': instance.grievance_id,
      'next_hearing_ date': instance.next_hearing_date,
      'case_status': instance.case_status,
      'remarks': instance.remarks,
      'created_at': instance.created_at,
    };
