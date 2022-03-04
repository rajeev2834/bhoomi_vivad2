import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'case_status.g.dart';

@JsonSerializable()
class CaseStatus {
  String circle;
  String panchayat;
  String name;
  String father_name;
  String contact;
  String address;
  String vivad_type;
  String mauza;
  String vivad_reason;
  String case_status;
  String created_at;

  CaseStatus(
      {required this.circle,
        required this.panchayat,
        required this.name,
        required this.contact,
        required this.father_name,
        required this.address,
        required this.mauza,
        required this.vivad_type,
        required this.vivad_reason,
      required this.case_status,
      required this.created_at});

  factory CaseStatus.fromJson(Map<String, dynamic> json) =>
      _$CaseStatusFromJson(json);

  Map<String, dynamic> toJson() => _$CaseStatusToJson(this);
}
