import 'dart:io';

import 'package:bhoomi_vivad/models/hearing.dart';
import 'package:bhoomi_vivad/models/vivad_status.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/hearing_update_provider.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/status_dialog_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../utils/loading_dialog.dart';
import '../../utils/size_config.dart';

class HearingUpdateArguments {
  final VivadStatus _vivadStatus;
  final String _token;
  final int _user;

  HearingUpdateArguments(this._vivadStatus, this._token, this._user);
}

class HearingTimeLineScreen extends StatefulWidget {
  static const routeName = '/hearing_timeline_screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HearingTimeLineScreenState();
  }
}

class _HearingTimeLineScreenState extends State<HearingTimeLineScreen> {
  Map<String, dynamic> statusUpdateVariable = new Map();

  DateTime? _dateTime;

  String? _selectedValue;

  TextEditingController _remarksController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _remarksController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as HearingUpdateArguments;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text("Case History"),
      ),
      body: showActionHistory(args),
      floatingActionButton:
          args._vivadStatus.case_status == "Hearing" && args._user != 0
              ? new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.cloud_upload_rounded),
                  backgroundColor: Theme.of(context).primaryColor,
                  tooltip: 'Update Case Status',
                  onPressed: () async {
                    StatusDialog().showStatusDialog(
                        context, args._vivadStatus, args._token, args._user);
                  })
              : Container(),
    );
  }

  Widget showActionHistory(HearingUpdateArguments args) {
    return HearingActionHistory(
      vivadStatus: args._vivadStatus,
      token: args._token,
      user: args._user,
    );
  }
}

class HearingActionHistory extends StatefulWidget {
  final VivadStatus vivadStatus;
  final String token;
  final int user;

  HearingActionHistory({
    Key? key,
    required this.vivadStatus,
    required this.token,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HearingActionHistory();
}

class _HearingActionHistory extends State<HearingActionHistory> {
  List<Hearing> hearing = [];
  bool _isLoading = false;
  String _token = "";
  int? _user;
  VivadStatus? _vivadStatus;
  DateFormat formatter = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    super.initState();

    _token = widget.token;
    _user = widget.user;
    _vivadStatus = widget.vivadStatus;

    setState(() {
      _isLoading = true;
    });

    _loadHearingData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadHearingData() async {
    var provider = Provider.of<HearingUpdateProvider>(context, listen: false);
    provider.getHearingData(_vivadStatus!.vivad_id).then((value) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((handleError) {
      if (handleError.toString().contains('SocketException')) {
        _showResultDialog(
            context, 'Error', 'Please check your network connection !!!');
      } else {
        _showResultDialog(context, 'Error', handleError.toString());
      }
    });
  }

  void _showResultDialog(BuildContext context, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(title);
          },
          child: Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog).then((value) {
      if (value.toString().contains('Error')) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Consumer<HearingUpdateProvider>(
            builder: (ctx, hearingUpdateProvider, _) {
            if (hearingUpdateProvider.hearingStatusList.hearings.length == 0) {
              return Center(
                child: Text('There is no action history.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    )),
              );
            } else {
              hearing = hearingUpdateProvider.hearingStatusList.hearings;
              return Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    nodeItemOverlap: true,
                    nodePosition: 0.050,
                    color: Colors.indigo,
                    connectorTheme: ConnectorThemeData(
                      thickness: 2.0,
                    ),
                    indicatorTheme: IndicatorThemeData(
                      position: 0.15,
                    ),
                  ),
                  builder: TimelineTileBuilder.connected(
                      indicatorBuilder: (_, index) {
                        if (index == 0) {
                          return DotIndicator(
                            size: 24.0,
                            child: Icon(
                              Icons.account_box_outlined,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          );
                        } else if (hearing[index - 1].case_status ==
                            "Hearing") {
                          return DotIndicator(
                            size: 24.0,
                            child: Icon(
                              Icons.calendar_month_sharp,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          );
                        } else {
                          return DotIndicator(
                            size: 24.0,
                            child: Icon(
                              Icons.check,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Case Registered: ',
                                            style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.indigo),
                                          ),
                                          SizedBox(
                                              width: 1.5 *
                                                  SizeConfig.widthMultiplier),
                                          Text(
                                            formatter
                                                .format(DateTime.parse(
                                                    _vivadStatus!.created_date))
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.heightMultiplier,
                                                color: Colors.indigo),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            1.25 * SizeConfig.heightMultiplier,
                                      ),
                                      Text(
                                        _vivadStatus!.vivad_id,
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            1.25 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Vivad Type: ',
                                            style: TextStyle(
                                              fontSize: 1.75 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 1.5 *
                                                  SizeConfig.widthMultiplier),
                                          Wrap(
                                            children: [
                                              Text(
                                                _vivadStatus!.vivad_type,
                                                style: TextStyle(
                                                  fontSize: 1.75 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            1.25 * SizeConfig.heightMultiplier,
                                      ),
                                      Text(
                                        'Case Description:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            0.625 * SizeConfig.heightMultiplier,
                                      ),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: [
                                          Text(
                                            _vivadStatus!.case_detail,
                                            style: TextStyle(
                                              height: 1.5,
                                              fontSize: 1.75 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            1.25 * SizeConfig.heightMultiplier,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Review Date: ',
                                            style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.indigo),
                                          ),
                                          SizedBox(
                                            width: 1.25 *
                                                SizeConfig.widthMultiplier,
                                          ),
                                          Text(
                                            formatter
                                                .format(DateTime.parse(
                                                    hearing[index - 1]
                                                        .created_at))
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 2 *
                                                  SizeConfig.heightMultiplier,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            1.25 * SizeConfig.heightMultiplier,
                                      ),
                                      Text(
                                        'Remarks: ',
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            0.625 * SizeConfig.heightMultiplier,
                                      ),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: [
                                          Text(
                                            hearing[index - 1].remarks,
                                            style: TextStyle(
                                              height: 1.5,
                                              fontSize: 1.75 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            0.625 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Case Status: ',
                                            style: TextStyle(
                                              fontSize: 1.75 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 1.25 *
                                                  SizeConfig.widthMultiplier),
                                          CustomTitle(
                                              case_status: hearing[index - 1]
                                                  .case_status),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            1.25 * SizeConfig.heightMultiplier,
                                      ),
                                      hearing[index - 1].case_status ==
                                              "Hearing"
                                          ? Row(
                                              children: <Widget>[
                                                Text(
                                                  'Next Hearing Date: ',
                                                  style: TextStyle(
                                                    fontSize: 1.75 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 1.25 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                Text(
                                                  formatter
                                                      .format(DateTime.parse(
                                                          hearing[index - 1]
                                                              .next_hearing_date))
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 1.75 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height:
                                            2.5 * SizeConfig.heightMultiplier,
                                      ),
                                    ],
                                  ),
                          ),
                      itemCount: hearing.length + 1));
            }
          });
  }

  Widget CustomTitle({required String case_status}) {
    var caseStatus = case_status == "Pending"
        ? "Case Registered"
        : case_status == "Hearing"
            ? "Hearing Scheduled"
            : case_status == "Rejected"
                ? "Case has been rejected."
                : case_status == "Closed"
                    ? "Case has been closed."
                    : "";
    return Text(
      caseStatus,
      style: TextStyle(
        fontSize: 2 * SizeConfig.heightMultiplier,
      ),
    );
  }
}
