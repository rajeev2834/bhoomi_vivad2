import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plot_detail.g.dart';

@JsonSerializable()
class PlotDetail {
    String chauhaddi;
    String circle_id;
    String image;
    String khata_no;
    String khesra_no;
    double latitude;
    double longitude;
    int mauza_id;
    String panchayat_id;
    String plot_id;
    int plot_nature_id;
    int plot_type_id;
    double rakwa;
    String remarks;
    int thana_no;

    PlotDetail({required this.chauhaddi, required this.circle_id, required this.image,
        required this.khata_no, required this.khesra_no, required this.latitude, required this.longitude,
        required this.mauza_id, required this.panchayat_id, required this.plot_id, required this.plot_nature_id,
        required this.plot_type_id, required this.rakwa, required this.remarks, required this.thana_no});

    factory PlotDetail.fromJson(Map<String, dynamic> json) => _$PlotDetailFromJson(json);

    Map<String, dynamic> toJson() => _$PlotDetailToJson(this);
}