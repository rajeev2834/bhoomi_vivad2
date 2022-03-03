import 'package:bhoomi_vivad/models/case_status.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GrievanceStatus extends StatefulWidget {

  GrievanceStatus({Key? key, required this.trackingId})
      : super(key: key);

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
  CaseStatus? _caseStatus;


  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _trackingIdController.text = widget.trackingId;
    var provider = Provider.of<GetApiData>(context, listen: false);
    provider.getGrievanceStatus(_trackingIdController.text).then((value) async{
      _caseStatus = provider.caseStatus;
      print(_caseStatus?.circle);
      setState(() {
        _isLoading = false;
      });
    });
  }


  @override
  void dispose() {
    _trackingIdController.dispose();
    super.dispose();
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
        body: _isLoading ? MySplashScreen() :FutureBuilder(
            future: ,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              else if (snapshot.hasError) {
                return Center(
                    child: Text('Error : ${snapshot.error}')
                );
              }
              else {
                final data = snapshot.data!;
                print(data);
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
                              Expanded(child: Text(_trackingIdController.text,
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
