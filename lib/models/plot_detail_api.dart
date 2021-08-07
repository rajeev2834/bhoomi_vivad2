import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plot_detail_api.g.dart';

class PlotDetailList{
  final List<PlotDetail> plot_details;

  PlotDetailList({
    required this.plot_details,
  });

  factory PlotDetailList.fromJson(List<dynamic> parsedJson) {
    List<PlotDetail> plot_details = [];
    plot_details = parsedJson.map((i)=>PlotDetail.fromJson(i)).toList();

    return new PlotDetailList(plot_details: plot_details);
  }
}

@JsonSerializable()
class PlotDetail {
  String chauhaddi;
  String circle;
  String image;
  String khata_no;
  String khesra_no;
  double latitude;
  double longitude;
  int mauza;
  String panchayat;
  String plot_uuid;
  int plot_nature;
  int plot_type;
  double rakwa;
  String remarks;
  String thana_no;
  int is_govtPlot;

  PlotDetail({required this.chauhaddi, required this.circle, required this.image,
    required this.khata_no, required this.khesra_no, required this.latitude, required this.longitude,
    required this.mauza, required this.panchayat, required this.plot_uuid, required this.plot_nature,
    required this.plot_type, required this.rakwa, required this.remarks, required this.thana_no, required this.is_govtPlot});

  factory PlotDetail.fromJson(Map<String, dynamic> json) => _$PlotDetailFromJson(json);

}