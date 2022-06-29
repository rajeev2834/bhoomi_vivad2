import 'package:bhoomi_vivad/screens/admin_module/screens/circle_wise_status_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../../all_vivad/vivad_pending_screen.dart';

class CaseStatusCards extends StatelessWidget {
  final String caseStatus;
  final int total;
  final int citizen;
  final int circle;
  final Color cardColor;

  CaseStatusCards({
    required this.caseStatus,
    required this.total,
    required this.citizen,
    required this.circle,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(
        bottom: 5.0,
      ),
      padding: EdgeInsets.all(10.0),
      height: 22 * SizeConfig.heightMultiplier,
      width: 45 * SizeConfig.widthMultiplier,
      child: GestureDetector(
        onTap: () {
          _circleWiseStatus(context, caseStatus, cardColor);
        },
        child: Card(
          elevation: 5.0,
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              2.5 * SizeConfig.heightMultiplier,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 3 * SizeConfig.heightMultiplier,
                ),
                alignment: Alignment.center,
                child: Text(
                  total.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 4.5 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        caseStatus,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 3 * SizeConfig.heightMultiplier,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 1.25 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        "Citizen Login: $citizen",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 1.5 * SizeConfig.heightMultiplier,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 0.625 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        "Circle Login: $circle",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 1.5 * SizeConfig.heightMultiplier,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _circleWiseStatus(
      BuildContext context, String caseStatus, Color cardColor) {
    var caseStatusList = ["Pending", "Hearing", "Rejected", "Resolved"];
    var caseStatusIndex = caseStatusList.indexOf(caseStatus);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CircleWiseStatusScreen(
        caseStatus: caseStatusIndex.toString(),
        cardColor: cardColor,
        duration: "",
      );
    }));
  }
}
