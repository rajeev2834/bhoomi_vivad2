import 'package:bhoomi_vivad/models/case_status.dart';
import 'package:bhoomi_vivad/models/grievance.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GrievanceStatus extends StatefulWidget {
  final tracking_id;

  GrievanceStatus({this.tracking_id});

  static const routeName = '/grievance_status';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GrievanceStatus();
  }
}

class _GrievanceStatus extends State<GrievanceStatus> {
  TextEditingController _trackingId = TextEditingController();
  late final Future<CaseStatus> _caseStatus;

  @override
  void initState() {
    super.initState();
    _trackingId.text = widget.tracking_id;
    getGrievanceData(_trackingId.text);
  }

  @override
  void dispose() {
    _trackingId.dispose();
    super.dispose();
  }

  Future<void> getGrievanceData(String _trackingId) async {
    var provider = Provider.of<GetApiData>(context, listen: false);
    await provider.getGrievanceStatus(_trackingId).then((value) {
      _caseStatus = value;
    }).catchError((onError) {

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
        body: FutureBuilder<CaseStatus>(
            future: _caseStatus,
            builder: (BuildContext context, AsyncSnapshot<CaseStatus> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MySplashScreen();
              }
              else if (snapshot.hasError) {
                return Center(
                    child: Text('Error : ${snapshot.error}')
                );
              }
              else {
                final data = snapshot.data !;
                return SafeArea(
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
                              Expanded(child: Text('Tracking Id',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),)),
                              Expanded(child: Text(_trackingId.text,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),)),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text('Circle',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),)),
                              Expanded(child: Text(data.circle,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),)),
                              Expanded(child: Text('Panchayat',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),)),
                              Expanded(child: Text(data.panchayat,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),)),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Text('Parivadi Details:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0,
                          ),),
                          Wrap(
                            children: [
                              Text(data.name
                                + ',  Ph:',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(
                                width: 1.0,
                              ),
                              Text(
                                data.contact,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            data.mauza +', '+data.address,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            maxLines: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text('Vivad Type: ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),)),
                              Expanded(child: Text(data.vivad_type,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text('Description: ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),)),
                              Expanded(child: Text(data.vivad_reason,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text('Case Status: ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),)),
                              Expanded(child: Text(data.case_status,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
        ),
      );
}
}
