// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grievance.dart';

// **************************************************************************
// JsonSerializableGenerator
//
  Grievance _$GrievanceFromJson(Map<String, dynamic> json) {
        return Grievance(
            address: json['address'] as String,
            circle: json['circle']  as String,
            contact: json['contact'] as String,
            demand_no: json['demand_no'] as String,
            father_name: json['father_name'] as String,
            khata_no: json['khata_no'] as int,
            khesra_no: json['khesra_no'] as int,
            mauza: json['mauza'] as String,
            name: json['name'] as String,
            panchayat: json['panchayat'] as int,
            party_address: json['party_address'] as String,
            party_contact: json['party_contact'] as String,
            party_father_name: json['party_father_name'] as String,
            party_name: json['party_name'] as String,
            vivad_reason: json['vivad_reason'] as String,
            vivad_type: json['vivad_type'] as int,
        );
    }

    Map<String, dynamic> _$GrievanceToJson(Grievance instance) => <String, dynamic>{
        'address': instance.address,
        'circle': instance.circle,
        'contact': instance.contact,
        'demand_no': instance.demand_no,
        'father_name': instance.father_name,
        'khata_no': instance.khata_no,
        'khesra_no': instance.khesra_no,
        'mauza': instance.mauza,
        'name': instance.name,
        'panchayat': instance.panchayat,
        'party_address': instance.party_address,
        'party_contact': instance.party_contact,
        'party_father_name': instance.party_father_name,
        'party_name': instance.party_name,
        'vivad_reason': instance.vivad_reason,
        'vivad_type': instance.vivad_type,
};