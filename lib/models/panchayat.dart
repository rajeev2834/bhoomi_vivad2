import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'panchayat.g.dart';

class PanchayatList{
    final List<Panchayat> panchayats;

    PanchayatList({
        required this.panchayats,
    });

    factory PanchayatList.fromJson(List<dynamic> parsedJson) {
        List<Panchayat> panchayats = [];
        panchayats = parsedJson.map((i)=>Panchayat.fromJson(i)).toList();

        return new PanchayatList(panchayats: panchayats);
    }
}


@JsonSerializable()
class Panchayat {
    String circle_id;
    String panchayat_id;
    String panchayat_name;
    String panchayat_name_hn;

    Panchayat({required this.circle_id, required this.panchayat_id, required this.panchayat_name, required this.panchayat_name_hn});

    factory Panchayat.fromJson(Map<String, dynamic> json) => _$PanchayatFromJson(json);

    Map<String, dynamic> toJson() => _$PanchayatToJson(this);
}