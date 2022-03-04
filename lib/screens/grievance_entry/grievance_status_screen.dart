import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GrievanceStatus extends StatefulWidget {
  GrievanceStatus({Key? key, required this.trackingId}) : super(key: key);

  String trackingId;

  static const routeName = '/grievance_status';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GrievanceStatus();
  }
}

class _GrievanceStatus extends State<GrievanceStatus> {
  TextEditingController _trackingIdController = TextEditingController();
  bool _isLoading = false;
  DateFormat formatter = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _trackingIdController.text = widget.trackingId;
    var provider = Provider.of<GetApiData>(context, listen: false);
    provider.getGrievanceStatus(_trackingIdController.text).then((value) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((handleError) {
      if (handleError.toString().contains('SocketException')) {
        _showResultDialog(
            context, 'Network Error', 'Check your Internet and try again !!!');
      } else
      if (handleError.toString().contains('Valid value range is empty')) {
        _showResultDialog(context, 'Error',
            'Tracking Id does not exist. Please check and try again.');
      }
      else {
        _showResultDialog(context, 'Error', handleError.toString());
      }
    });
  }

  @override
  void dispose() {
    _trackingIdController.dispose();
    super.dispose();
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
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Text('Grievance Status'),
        ),
        body: _isLoading
            ? MySplashScreen()
            : WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              // show the confirm dialog
              await showDialog(
                  context: context,
                  builder: (_) =>
                      AlertDialog(
                        title: const Text('Confirm'),
                        content: Text('Are you sure want to exit ?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                willLeave = true;
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                              },
                              child: const Text('Exit')),
                          ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'))
                        ],
                      ));
              return willLeave;
            },
            child: Consumer<GetApiData>(
                builder: (context, getApiData, _) =>
                    SafeArea(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          height: screenHeight,
                          width: screenWidth,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        'Tracking Id: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        _trackingIdController.text,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        'Circle:',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        getApiData.caseStatus.circle,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        'Panchayat:',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        getApiData.caseStatus.panchayat,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Parivadi Details:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    getApiData.caseStatus.name + ',  Mo:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Text(
                                    getApiData.caseStatus.contact.replaceAll(
                                        "-", "").replaceAll(")", "").replaceAll(
                                        "(", "").replaceAll(" ", ""),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    getApiData.caseStatus.mauza + ', ',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.0,
                                  ),
                                  Text(
                                    getApiData.caseStatus.address,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        'Vivad Type: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        getApiData.caseStatus.vivad_type,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        'Description: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        getApiData.caseStatus.vivad_reason,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        'Registered Date: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        formatter
                                            .format(DateTime.parse(getApiData
                                            .caseStatus.created_at))
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        'Case Status: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  Expanded(
                                      child: Text(
                                        getApiData.caseStatus.case_status,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))));
  }
}
