import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mauza.g.dart';

class MauzaList{
    final List<Mauza> mauzas;

    MauzaList({
        required this.mauzas,
    });

    factory MauzaList.fromJson(List<dynamic> parsedJson) {
        List<Mauza> mauzas = [];
        mauzas = parsedJson.map((i)=>Mauza.fromJson(i)).toList();

        return new MauzaList(mauzas: mauzas);
    }
}

@JsonSerializable()
class Mauza {
    String circle_id;
    int mauza_id;
    String mauza_name_hn;
    String panchayat_id;

    Mauza({required this.circle_id, required this.mauza_id, required this.mauza_name_hn, required this.panchayat_id});

    factory Mauza.fromJson(Map<String, dynamic> json) => _$MauzaFromJson(json);

    Map<String, dynamic> toJson() => _$MauzaToJson(this);
}