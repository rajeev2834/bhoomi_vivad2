// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vivad_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VivadStatus _$VivadStatusFromJson(Map<String, dynamic> json) {
  return VivadStatus(
    id: json['id'] as int,
    vivad_id: json.containsKey('vivad_id')
        ? json['vivad_id'] as String
        : json['grievance_id'] as String,
    register_no: json['register_no'] ?? '',
    register_date: json['register_date'] ?? '',
    circle: json['circle_name'] as String,
    panchayat: json['panchayat_name'] as String,
    first_party_name: json.containsKey('first_party_name')
        ? json['first_party_name'] as String
        : json['name'] as String,
    first_party_address: json.containsKey('address')
        ? json['address'] ?? ''
        : json['first_party_address'] ?? '',
    first_party_contact: json.containsKey('contact')
        ? json['contact'] ?? ''
        : json['first_party_contact'] ?? '',
    second_party_address: json.containsKey('party_address')
        ? json['party_address'] ?? ''
        : json['second_party_address'] ?? '',
    second_party_contact: json.containsKey('party_contact')
        ? json['party_contact'] ?? ''
        : json['second_party_contact'] ?? '',
    second_party_name: json.containsKey('party_name')
        ? json['party_name'] ?? ''
        : json['second_party_name'] ?? '',
    thana_no: json['thana_no'] ?? '',
    mauza: json['mauza'] ?? '',
    khata_no: json['khata_no'] ?? '',
    khesra_no: json['khesra_no'] ?? '',
    rakwa: json['rakwa'] ?? '',
    chauhaddi: json['chauhaddi'] ?? '',
    vivad_type: json['vivad_type_name'] as String,
    case_detail: json.containsKey('vivad_reason')
        ? json['vivad_reason'] ?? ''
        : json['case_detail'] ?? '',
    is_violence: json['is_violence'] as int,
    violence_detail: json['violence_detail'] ?? '',
    is_fir: json['is_fir'] as int,
    notice_order: json['notice_order'] ?? '',
    is_courtpending: json['is_courtpending'] as int,
    court_status: json['court_status'] ?? '',
    case_status: json['case_status'] ?? '',
    next_hearing_date: json['next_hearing_date'] ?? '',
    remarks: json['remarks'] ?? '',
    created_date: json['created_at'] ?? '',
  );
}

Map<String, dynamic> _$VivadStatusToJson(VivadStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vivad_id': instance.vivad_id,
      'register_no': instance.register_no,
      'register_date': instance.register_date,
      'circle': instance.circle,
      'panchayat': instance.panchayat,
      'first_party_name': instance.first_party_name,
      'first_party_contact': instance.first_party_contact,
      'first_party_address': instance.first_party_address,
      'second_party_name': instance.second_party_name,
      'second_party_contact': instance.second_party_contact,
      'second_party_address': instance.second_party_address,
      'thana_no': instance.thana_no,
      'mauza': instance.mauza,
      'khata_no': instance.khata_no,
      'khesra_no': instance.khesra_no,
      'rakwa': instance.rakwa,
      'chauhaddi': instance.chauhaddi,
      'vivad_type': instance.vivad_type,
      'case_detail': instance.case_detail,
      'is_violence': instance.is_violence,
      'violence_detail': instance.violence_detail,
      'is_fir': instance.is_fir,
      'notice_order': instance.notice_order,
      'is_courtpending': instance.is_courtpending,
      'court_status': instance.court_status,
      'case_status': instance.case_status,
      'next_hearing_date': instance.next_hearing_date,
      'remarks': instance.remarks,
      'created_date': instance.created_date,
    };
