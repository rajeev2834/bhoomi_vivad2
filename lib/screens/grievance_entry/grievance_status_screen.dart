import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../hearing_timeline/hearing_timeline_screen.dart';

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
      } else if (handleError
          .toString()
          .contains('Valid value range is empty')) {
        _showResultDialog(context, 'Error',
            'Tracking Id does not exist. Please check and try again.');
      } else {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                      builder: (_) => AlertDialog(
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
                    builder: (context, getApiData, _) => SafeArea(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              height: screenHeight,
                              width: screenWidth,
                              padding: EdgeInsets.all(
                                  2 * SizeConfig.heightMultiplier),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Grievance Id: ',
                                        style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        _trackingIdController.text,
                                        style: TextStyle(
                                          fontSize:
                                              1.9 * SizeConfig.heightMultiplier,
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
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            17.5 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData.vivadStatus.circle,
                                        style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
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
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData.vivadStatus.panchayat,
                                        style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
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
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            17.5 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData.vivadStatus.mauza,
                                        style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
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
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            17.5 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData.vivadStatus.khata_no
                                            .toString(),
                                        style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
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
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            17.5 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData.vivadStatus.khesra_no
                                            .toString(),
                                        style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
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
                                        getApiData
                                                .vivadStatus.first_party_name +
                                            ',  Mo:',
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 0.5 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData
                                            .vivadStatus.first_party_contact
                                            .replaceAll("-", "")
                                            .replaceAll(")", "")
                                            .replaceAll("(", "")
                                            .replaceAll(" ", ""),
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
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
                                        getApiData
                                            .vivadStatus.first_party_address,
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
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
                                        getApiData
                                                .vivadStatus.second_party_name +
                                            ',  Mo:',
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 0.5 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData
                                            .vivadStatus.second_party_contact
                                            .replaceAll("-", "")
                                            .replaceAll(")", "")
                                            .replaceAll("(", "")
                                            .replaceAll(" ", ""),
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
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
                                        getApiData
                                            .vivadStatus.second_party_address,
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
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
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              2.5 * SizeConfig.widthMultiplier),
                                      Wrap(
                                        children: [
                                          Text(
                                            getApiData.vivadStatus.vivad_type,
                                            style: TextStyle(
                                              fontSize: 1.9 *
                                                  SizeConfig.heightMultiplier,
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
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: [
                                      Text(
                                        getApiData.vivadStatus.case_detail,
                                        style: TextStyle(
                                          height: 1.5,
                                          fontSize:
                                              1.9 * SizeConfig.heightMultiplier,
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
                                          fontSize:
                                              2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            1.25 * SizeConfig.heightMultiplier,
                                      ),
                                      Text(
                                        formatter
                                            .format(DateTime.parse(getApiData
                                                .vivadStatus.created_date))
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 1.75 *
                                              SizeConfig.heightMultiplier,
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
                                        'Case Status: ',
                                        style: TextStyle(
                                          fontSize:
                                          2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                       width:
                                        1.25 * SizeConfig.widthMultiplier,
                                      ),
                                      Text(
                                        getApiData.vivadStatus.case_status,
                                        style: TextStyle(
                                          fontSize: 2 *
                                              SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.5 * SizeConfig.heightMultiplier,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          5 * SizeConfig.widthMultiplier,
                                      vertical:
                                          2.5 * SizeConfig.heightMultiplier,
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.indigo,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.5 *
                                                SizeConfig.heightMultiplier,
                                            horizontal:
                                                2 * SizeConfig.widthMultiplier),
                                        child: Text(
                                          'Action History',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 2.2 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await Navigator.of(context).pushNamed(
                                          HearingTimeLineScreen.routeName,
                                          arguments: HearingUpdateArguments(
                                              getApiData.vivadStatus,
                                              "",
                                              0),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))));
  }
}
