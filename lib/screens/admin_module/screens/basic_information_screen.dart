import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import 'circle_wise_status_screen.dart';

class BasicInformationList extends StatelessWidget {
  final String title;
  final int total;
  final int citizen;
  final int circle;
  final IconData icon;
  final Color iconColor;
  final String duration;

  BasicInformationList(
      {required this.title,
      required this.total,
      required this.citizen,
      required this.circle,
      required this.icon,
      required this.iconColor,
      required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 25.0,
        top: 8.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CircleWiseStatusScreen(
              caseStatus: "",
              cardColor: iconColor,
              duration: duration,
            );
          }));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 2.5 * SizeConfig.heightMultiplier,
              backgroundColor: iconColor,
              child: Icon(
                icon,
                size: 2.25 * SizeConfig.heightMultiplier,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 2.5 * SizeConfig.widthMultiplier,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 1.9 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Citizen Login: $citizen , Circle Login: $circle",
                  style: TextStyle(
                    fontSize: 1.7 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
