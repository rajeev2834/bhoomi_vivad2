import 'package:json_annotation/json_annotation.dart';

part 'circle.g.dart';

class CircleList{
    final List<Circle> circles;

    CircleList({
        required this.circles,
    });

    factory CircleList.fromJson(List<dynamic> parsedJson) {
        List<Circle> circles = [];
        circles = parsedJson.map((i)=>Circle.fromJson(i)).toList();

        return new CircleList(circles: circles);
    }
}

@JsonSerializable()
class Circle {
    String circleId;
    String circleNameHn;
    int user;

    Circle({required this.circleId, required this.circleNameHn, required this.user});

    factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);

    Map<String, dynamic> toJson() => _$CircleToJson(this);
}