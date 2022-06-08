import 'package:bhoomi_vivad/models/vivad_status.dart';
import 'package:bhoomi_vivad/screens/all_vivad/status_update_provider.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/hearing_timeline_screen.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/hearing_update_provider.dart';
import 'package:bhoomi_vivad/utils/loading_dialog.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';

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

  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _formKey = GlobalKey<FormState>();

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
                            onPressed: () {
                              _showStatusDialog(context, args);
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Text("Schedule Hearing"),
        value: "Hearing",
      ),
      DropdownMenuItem(
        child: Text("Reject Case"),
        value: "Rejected",
      ),
      DropdownMenuItem(
        child: Text("Close Case"),
        value: "Closed",
      ),
    ];
    return menuItems;
  }

  _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime(2222),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _dateTime = picked;
        controller.text = DateFormat("yyyy-MM-dd").format(_dateTime!);
      });
  }

  _showStatusDialog(BuildContext context, StatusUpdateArguments args) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Update Case Status',
              style: TextStyle(
                fontSize: 2 * SizeConfig.heightMultiplier,
              ),
            ),
            insetPadding: EdgeInsets.all(10.0),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Stack(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Choose Status",
                              contentPadding: EdgeInsets.all(10.0),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: dropdownItems,
                            //value: _selectedValue,
                            onChanged: ((value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            }),
                            validator: (value) =>
                                value == null ? 'Case Status required' : null,
                          ),
                          SizedBox(height: 1.25 * SizeConfig.heightMultiplier),
                          _selectedValue == 'Hearing'
                              ? GestureDetector(
                                  onTap: () =>
                                      _selectDate(context, _dateTimeController),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      keyboardType: TextInputType.datetime,
                                      controller: _dateTimeController,
                                      decoration: InputDecoration(
                                        labelText: 'Next Hearing Date',
                                        suffixIcon: Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.indigo,
                                        ),
                                        labelStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 15.0),
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter next hearing date'
                                          : null,
                                      onSaved: (value) {
                                        setState(() {
                                          _dateTimeController.text = value!;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 1.25 * SizeConfig.heightMultiplier,
                          ),
                          TextFormField(
                            controller: _remarksController,
                            maxLength: 500,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Remaks, if any',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15.0),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onSaved: (value) {
                              setState(() {
                                _remarksController.text = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _dateTimeController.clear();
                  _remarksController.clear();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      statusUpdateVariable['token'] = args._token;
                      statusUpdateVariable['user'] = args._user;
                      statusUpdateVariable['id'] = args._vivadStatus.id;
                      statusUpdateVariable['vivad_id'] =
                          args._vivadStatus.vivad_id;
                      statusUpdateVariable['case_status'] = _selectedValue;
                      statusUpdateVariable['hearingDate'] =
                          _dateTimeController.text;
                      statusUpdateVariable['remarks'] = _remarksController.text;
                      Navigator.of(context).pop(_submitStatus());
                    }
                  });
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }

  Future<void> _submitStatus() async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);
      await Provider.of<StatusUpdateProvider>(context, listen: false)
          .updateStatus(statusUpdateVariable)
          .then((value) async {
        await Provider.of<HearingUpdateProvider>(context, listen: false)
            .updateHearing(statusUpdateVariable)
            .then((value) {
          Navigator.of(this.context, rootNavigator: true).pop();
          _showAlertDialog(
              context, "Success", "Case Status updated successfully !!!", 0);
        });
      }).catchError((handleError) {
        Navigator.of(this.context, rootNavigator: true).pop();
        if (handleError.toString().contains('SocketException')) {
          _showAlertDialog(
              context, "Error", "Please check your netowrk !!!", 1);
        } else {
          _showAlertDialog(context, "Error", handleError.toString(), 1);
        }
      });
    } on HttpException catch (error) {
      Navigator.of(this.context, rootNavigator: true).pop();
      _showAlertDialog(context, "Error", error.toString(), 1);
    } catch (error) {
      Navigator.of(this.context, rootNavigator: true).pop();
      const errorMessage =
          'Could not connect to the server. Please try again later !!!';
      _showAlertDialog(context, "Error", errorMessage.toString(), 1);
    }
  }

  void _showAlertDialog(
      BuildContext context, String title, String message, int success) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.9 * SizeConfig.heightMultiplier),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(success);
          },
          child: Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog).then((value) {
      if (value == 0) {
        Navigator.of(context).pop(value);
      }
    });
  }
}
