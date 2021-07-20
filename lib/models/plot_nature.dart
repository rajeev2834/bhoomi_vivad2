import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plot_nature.g.dart';

class PlotNatureList{
    final List<PlotNature> plot_natures;

    PlotNatureList({
        required this.plot_natures,
    });

    factory PlotNatureList.fromJson(List<dynamic> parsedJson) {
        List<PlotNature> plot_natures = [];
        plot_natures = parsedJson.map((i)=>PlotNature.fromJson(i)).toList();

        return new PlotNatureList(plot_natures: plot_natures);
    }
}


@JsonSerializable()
class PlotNature {
    int id;
    String plot_nature;

    PlotNature({required this.id, required this.plot_nature});

    factory PlotNature.fromJson(Map<String, dynamic> json) => _$PlotNatureFromJson(json);

    Map<String, dynamic> toJson() => _$PlotNatureToJson(this);

}