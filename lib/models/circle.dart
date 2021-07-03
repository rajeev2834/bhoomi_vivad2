import 'package:json_annotation/json_annotation.dart';

part 'circle.g.dart';

@JsonSerializable()
class Circle {
    String circleId;
    String circleNameHn;

    Circle({required this.circleId, required this.circleNameHn});

    factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);

    Map<String, dynamic> toJson() => _$CircleToJson(this);
}