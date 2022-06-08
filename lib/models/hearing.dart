import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hearing.g.dart';

class HearingList{
  final List<Hearing> hearings;

  HearingList({
    required this.hearings,
  });

  factory HearingList.fromJson(List<dynamic> parsedJson) {
    List<Hearing> hearings = [];
    hearings = parsedJson.map((i)=>Hearing.fromJson(i)).toList();

    return new HearingList(hearings: hearings);
  }
}


@JsonSerializable()
class Hearing {
  int id;
  String grievance_id;
  String hearing_date;
  String case_status;
  String next_date;
  String remarks;

  Hearing({required this.id, required this.grievance_id,  required this.hearing_date, required this.remarks,
  required this.case_status, required this.next_date});

  factory Hearing.fromJson(Map<String, dynamic> json) => _$HearingFromJson(json);


  Map<String, dynamic> toJson() => _$HearingToJson(this);

}