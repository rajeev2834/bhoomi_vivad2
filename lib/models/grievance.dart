import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'grievance.g.dart';

@JsonSerializable()
class Grievance {
  String circle;
  int panchayat;
  String name;
  String father_name;
  String contact;
  String address;
  String party_name;
  String party_father_name;
  String party_contact;
  String party_address;
  int vivad_type;
  String mauza;
  int khata_no;
  int khesra_no;
  String demand_no;
  String vivad_reason;

  Grievance(
      {required this.circle,
      required this.panchayat,
      required this.name,
      required this.contact,
      required this.father_name,
      required this.address,
      required this.party_name,
      required this.party_father_name,
      required this.party_contact,
      required this.party_address,
      required this.mauza,
      required this.vivad_type,
      required this.khesra_no,
      required this.khata_no,
      required this.demand_no,
      required this.vivad_reason});

  factory Grievance.fromJson(Map<String, dynamic> json) =>
      _$GrievanceFromJson(json);

  Map<String, dynamic> toJson() => _$GrievanceToJson(this);
}
