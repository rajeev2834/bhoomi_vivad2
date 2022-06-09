import 'package:bhoomi_vivad/screens/landing/help_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class TimeLineDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TimeLineDemoState();
  }
}

class _TimeLineDemoState extends State<TimeLineDemo> {
  List<DemoData> demoData = [
    DemoData(case_status: "pending"),
    DemoData(case_status: "hearing"),
    DemoData(case_status: "rejected"),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline Demo"),
      ),
      body: Timeline.tileBuilder(
          theme: TimelineThemeData(
            nodeItemOverlap: true,
            nodePosition: 0.050,
            color: Colors.indigo,
            connectorTheme: ConnectorThemeData(
              thickness: 2.0,
            ),
          ),
          builder: TimelineTileBuilder.connected(
              indicatorBuilder: (_, index) {
                if (demoData[index].case_status == "pending") {
                  return DotIndicator(
                    size: 24.0,
                    child: Icon(
                      Icons.account_box_outlined,
                      color: Colors.white,
                      size: 16.0,
                    ),
                  );
                } else {
                  return DotIndicator(
                    size: 24.0,
                    child: Icon(
                      Icons.calendar_month_sharp,
                      color: Colors.white,
                      size: 16.0,
                    ),
                  );
                }
              },
              connectorBuilder: (_, index, __) => SolidLineConnector(
                    color: Colors.indigo,
                  ),
              contentsAlign: ContentsAlign.basic,
              contentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: index == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Grievance Id :"),
                              CustomTitle(title: demoData[0].case_status),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Timeline Index is $index"),
                              SizedBox(height: 2.0),
                              CustomTitle(title: demoData[1].case_status),
                            ],
                          ),
                  ),
              itemCount: 3)),
    );
  }

  Widget CustomTitle({required String title}) {
    var caseStatus = title == "pending"
        ? "Case Registered"
        : title == "hearing"
            ? "Hearing Scheduled"
            : title == "rejected"
                ? "Case has been rejected."
                : title == "disposed"
                    ? "Case has been closed."
                    : "";
    return Text(caseStatus);
  }
}

class DemoData {
  final String case_status;

  DemoData({required this.case_status});
}
