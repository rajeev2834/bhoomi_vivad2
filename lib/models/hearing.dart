import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hearing.g.dart';

@JsonSerializable()
class Hearing {
  int id;
  String? vivad_id;
  DateTime? hearing_date;
  String? remarks;
  bool first_party;
  bool second_party;


  Hearing({required this.id, required this.vivad_id, required this.hearing_date, required this.remarks,
  required this.first_party, required this.second_party});

  factory Hearing.fromJson(Map<String, dynamic> json) => _$HearingFromJson(json);


  Map<String, dynamic> toJson() => _$HearingToJson(this);

}