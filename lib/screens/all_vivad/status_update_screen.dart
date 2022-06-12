import 'package:bhoomi_vivad/models/vivad_status.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/hearing_timeline_screen.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/status_dialog_screen.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class StatusUpdateArguments {
  final VivadStatus _vivadStatus;
  final String _token;
  final int _user;

  StatusUpdateArguments(this._vivadStatus, this._token, this._user);
}

class StatusUpdateScreen extends StatefulWidget {
  static const routeName = '/status_update_screen';

  @override
  _StatusUpdateScreenState createState() => _StatusUpdateScreenState();
}

class _StatusUpdateScreenState extends State<StatusUpdateScreen> {
  Map<String, dynamic> statusUpdateVariable = new Map();
  DateFormat formatter = DateFormat("dd-MM-yyyy");

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
    // TODO: implement build
    final args =
        ModalRoute.of(context)!.settings.arguments as StatusUpdateArguments;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text("Review Case Status"),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(0.625 * SizeConfig.heightMultiplier),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding:
                EdgeInsets.only(bottom: 1.75 * SizeConfig.heightMultiplier),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.25 * SizeConfig.widthMultiplier,
                        vertical: 1.25 * SizeConfig.heightMultiplier,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Grievance Id: ',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5 * SizeConfig.widthMultiplier),
                                Text(
                                  args._vivadStatus.vivad_id,
                                  style: TextStyle(
                                    fontSize: 1.9 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Circle:',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 17.5 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  args._vivadStatus.circle,
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Panchayat:',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 10 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  args._vivadStatus.panchayat,
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Mauza:',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 17.5 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  args._vivadStatus.mauza,
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Khata:',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 17.5 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  args._vivadStatus.khata_no.toString(),
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Khesra:',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 17.5 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  args._vivadStatus.khesra_no.toString(),
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Text(
                              'Parivadi Details:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 2 * SizeConfig.heightMultiplier,
                              ),
                            ),
                            SizedBox(
                              height: 0.625 * SizeConfig.heightMultiplier,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  args._vivadStatus.first_party_name + ',  Mo:',
                                  style: TextStyle(
                                    fontSize:
                                        1.75 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                                SizedBox(
                                  width: 0.5 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  args._vivadStatus.first_party_contact
                                      .replaceAll("-", "")
                                      .replaceAll(")", "")
                                      .replaceAll("(", "")
                                      .replaceAll(" ", ""),
                                  style: TextStyle(
                                    fontSize:
                                        1.75 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.625 * SizeConfig.heightMultiplier,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  args._vivadStatus.first_party_address,
                                  style: TextStyle(
                                    fontSize:
                                        1.75 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Text(
                              'Vadi Details:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 2 * SizeConfig.heightMultiplier,
                              ),
                            ),
                            SizedBox(
                              height: 0.625 * SizeConfig.heightMultiplier,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  args._vivadStatus.second_party_name +
                                      ',  Mo:',
                                  style: TextStyle(
                                    fontSize:
                                        1.75 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                                SizedBox(
                                  width: 0.5 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  args._vivadStatus.second_party_contact
                                      .replaceAll("-", "")
                                      .replaceAll(")", "")
                                      .replaceAll("(", "")
                                      .replaceAll(" ", ""),
                                  style: TextStyle(
                                    fontSize:
                                        1.75 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.625 * SizeConfig.heightMultiplier,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  args._vivadStatus.second_party_address,
                                  style: TextStyle(
                                    fontSize:
                                        1.75 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.25 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Vivad Type: ',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                    width: 2.5 * SizeConfig.widthMultiplier),
                                Wrap(
                                  children: [
                                    Text(
                                      args._vivadStatus.vivad_type,
                                      style: TextStyle(
                                        fontSize:
                                            1.9 * SizeConfig.heightMultiplier,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Text(
                              'Case Description:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 2 * SizeConfig.heightMultiplier,
                              ),
                            ),
                            SizedBox(
                              height: 0.625 * SizeConfig.heightMultiplier,
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(
                                  args._vivadStatus.case_detail,
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 1.9 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Registered Date: ',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 1.25 * SizeConfig.heightMultiplier,
                                ),
                                Text(
                                  formatter
                                      .format(DateTime.parse(
                                          args._vivadStatus.created_date))
                                      .toString(),
                                  style: TextStyle(
                                    fontSize:
                                        1.75 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Case Status: ',
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                                Text(
                                  args._vivadStatus.case_status,
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier,
                            ),
                            args._vivadStatus.case_status == 'Hearing'
                                ? Row(
                                    children: <Widget>[
                                      Text(
                                        'Hearing Date: ',
                                        style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              2 * SizeConfig.widthMultiplier),
                                      Text(
                                        formatter
                                            .format(DateTime.parse(args
                                                ._vivadStatus
                                                .next_hearing_date))
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ]),
                    ),
                  ),
                  args._vivadStatus.case_status == 'Pending'
                      ? Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 2.5 * SizeConfig.heightMultiplier,
                          ),
                          alignment: Alignment.bottomCenter,
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.5 * SizeConfig.heightMultiplier,
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Text(
                                'Update Status',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.2 * SizeConfig.heightMultiplier,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              StatusDialog().showStatusDialog(context,
                                  args._vivadStatus, args._token, args._user);
                            },
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 2.5 * SizeConfig.heightMultiplier,
                          ),
                          alignment: Alignment.bottomCenter,
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.5 * SizeConfig.heightMultiplier,
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Text(
                                'Action History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.2 * SizeConfig.heightMultiplier,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(
                                HearingTimeLineScreen.routeName,
                                arguments: HearingUpdateArguments(
                                    args._vivadStatus, args._token, args._user),
                              );
                            },
                          ),
                        ),
                ]),
          ),
        ),
      ),
    );
  }
}
