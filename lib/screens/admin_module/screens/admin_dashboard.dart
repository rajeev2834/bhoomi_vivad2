import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../color/custom_colors.dart';
import '../../../utils/size_config.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard_screen';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          BasicInformationList(
              title: "Total Grievance",
              total: 100,
              pending: 50,
              resolved: 50,
              icon: Icons.cases,
              iconColor: CustomColors.kRed),
          SizedBox(
            height: 1.9 * SizeConfig.heightMultiplier,
          ),
          BasicInformationList(
              title: "Registered during Last Month",
              total: 70,
              pending: 50,
              resolved: 20,
              icon: Icons.calendar_month,
              iconColor: CustomColors.kDarkYellow),
          SizedBox(
            height: 1.9 * SizeConfig.heightMultiplier,
          ),
        ],
      ),
    );
  }
}

class BasicInformationList extends StatelessWidget {
  final String title;
  final int total;
  final int pending;
  final int resolved;
  final IconData icon;
  final Color iconColor;

  BasicInformationList(
      {required this.title,
      required this.total,
      required this.pending,
      required this.resolved,
      required this.icon,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 2.5 * SizeConfig.heightMultiplier,
          backgroundColor: iconColor,
          child: Icon(
            icon,
            size: 1.9 * SizeConfig.heightMultiplier,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 2.5 * SizeConfig.widthMultiplier,
        ),
        Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Pending: $pending , Resolved: $resolved",
              style: TextStyle(
                fontSize: 1.9 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
