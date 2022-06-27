import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LoadingPercentageDemo extends StatelessWidget {
  final Color cardColor;
  final String caseStatus;
  final double loadingPercentage;
  final int total;

  LoadingPercentageDemo(
      {required this.cardColor,
      required this.caseStatus,
      required this.loadingPercentage,
      required this.total});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 5.0,),
      padding: EdgeInsets.all(10.0),
      height: 26 * SizeConfig.heightMultiplier,
      child: Card(
        elevation: 5.0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5 * SizeConfig.heightMultiplier,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularPercentIndicator(
                animation: true,
                radius: 7.5 * SizeConfig.heightMultiplier,
                percent: loadingPercentage,
                lineWidth: 0.5 * SizeConfig.heightMultiplier,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white10,
                progressColor: Colors.white,
                center: Text(
                  '${(loadingPercentage * 100).round()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(caseStatus,
                      style: TextStyle(
                        fontSize: 1.75 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                  Text(
                    'Total: $total Cases',
                    style: TextStyle(
                      fontSize: 1.5 * SizeConfig.heightMultiplier,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
