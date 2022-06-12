import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/vivad_status.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/size_config.dart';
import '../all_vivad/status_update_provider.dart';
import 'hearing_update_provider.dart';
import 'package:bhoomi_vivad/models/http_exception.dart';

class StatusDialog {
  Map<String, dynamic> statusUpdateVariable = new Map();

  DateTime? _dateTime;

  String? _selectedValue;

  TextEditingController _remarksController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late BuildContext _buildContext;

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

  _selectDate(BuildContext context, TextEditingController controller, setState) async {
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

   Future<void> showStatusDialog(BuildContext buildContext,
      VivadStatus _vivadStatus, String _token, int _user) async {
    _buildContext = buildContext;
    showDialog(
        barrierDismissible: false,
        context: buildContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState){
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
                                _selectDate(context, _dateTimeController, setState),
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
                      statusUpdateVariable['token'] = _token;
                      statusUpdateVariable['user'] = _user;
                      statusUpdateVariable['id'] = _vivadStatus.id;
                      statusUpdateVariable['vivad_id'] =
                          _vivadStatus.vivad_id;
                      statusUpdateVariable['case_status'] = _selectedValue;
                      statusUpdateVariable['hearingDate'] =
                          _dateTimeController.text;
                      statusUpdateVariable['remarks'] = _remarksController.text;
                      Navigator.of(context).pop(_submitStatus(buildContext));
                    }
                  });
                },
                child: Text('Save'),
              ),
            ],
          );});
        });
  }
  Future<void> _submitStatus(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);
      await Provider.of<StatusUpdateProvider>(context, listen: false)
          .updateStatus(statusUpdateVariable)
          .then((value) async {
        await Provider.of<HearingUpdateProvider>(context, listen: false)
            .updateHearing(statusUpdateVariable)
            .then((value) {
          Navigator.of(context, rootNavigator: true).pop();
          _showAlertDialog(
              _buildContext, "Success", "Case Status updated successfully !!!", 0);
        });
      }).catchError((handleError) {
        Navigator.of(context, rootNavigator: true).pop();
        if (handleError.toString().contains('SocketException')) {
          _showAlertDialog(
              _buildContext, "Error", "Please check your netowrk !!!", 1);
        } else {
          _showAlertDialog(_buildContext, "Error", handleError.toString(), 1);
        }
      });
    } on HttpException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      _showAlertDialog(_buildContext, "Error", error.toString(), 1);
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      const errorMessage =
          'Could not connect to the server. Please try again later !!!';
      _showAlertDialog(_buildContext, "Error", errorMessage.toString(), 1);
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
