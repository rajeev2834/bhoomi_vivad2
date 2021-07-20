import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plot_type.g.dart';

class PlotTypeList{
    final List<PlotType> plot_types;

    PlotTypeList({
        required this.plot_types,
    });

    factory PlotTypeList.fromJson(List<dynamic> parsedJson) {
        List<PlotType> plot_types = [];
        plot_types = parsedJson.map((i)=>PlotType.fromJson(i)).toList();

        return new PlotTypeList(plot_types: plot_types);
    }
}


@JsonSerializable()
class PlotType {
    int id;
    String plot_type;

    PlotType({required this.id, required this.plot_type});

    factory PlotType.fromJson(Map<String, dynamic> json) => _$PlotTypeFromJson(json);

    Map<String, dynamic> toJson() => _$PlotTypeToJson(this);
}