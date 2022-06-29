import 'package:bhoomi_vivad/screens/all_vivad/status_update_provider.dart';
import 'package:bhoomi_vivad/screens/body_home_screen.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../color/custom_colors.dart';
import '../../../providers/addBaseData.dart';
import '../../../utils/size_config.dart';
import 'basic_information_screen.dart';
import 'case_status_cards.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;
  String _token = "";
  List<Map<String, dynamic>> _caseStatusCount = [];
  var _totalCircleCount = 0;
  var _totalCitizenCount = 0;
  var _pendingCitizen = 0;
  var _pendingCircle = 0;
  var _hearingCitizen = 0;
  var _hearingCircle = 0;
  var _rejectedCitizen = 0;
  var _rejectedCircle = 0;
  var _closedCitizen = 0;
  var _closedCircle = 0;
  var _weekCitizen = 0;
  var _weekCircle = 0;
  var _monthCitizen = 0;
  var _monthCircle = 0;

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      _isLoading = true;
    });
    _loadDashboardData();
    super.initState();
  }

  Future<void> _loadDashboardData() async {
    var provider = Provider.of<AddBaseData>(context, listen: false);
    await provider.getToken().then((value) async {
      _token = provider.token;
      await Provider.of<StatusUpdateProvider>(context, listen: false)
          .countCaseStatus(_token, "", "")
          .then((value) {
        setState(() {
          _isLoading = false;
          _caseStatusCount = value;
          _getDashBoardData();
          _getWeekData();
          _getMonthData();
        });
      }).catchError((handleError) {
        setState(() {
          _isLoading = false;
        });
        if (handleError.toString().contains('SocketException')) {
          _showResultDialog(
              context, 'Error', 'Please check your network connection !!!');
        } else {
          _showResultDialog(context, 'Error', handleError.toString());
        }
      });
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

  Future<void> _getDashBoardData() async {
    _caseStatusCount
        .sort((a, b) => a['case_status'].compareTo(b['case_status']));
    _caseStatusCount.forEach((element) {
      _totalCitizenCount += element['total_grievance'] as int;
      _totalCircleCount += element['total_vivad'] as int;
      switch (element['case_status']) {
        case 0:
          _pendingCitizen = element['total_grievance'] as int;
          _pendingCircle = element['total_vivad'] as int;
          break;
        case 1:
          _hearingCitizen = element['total_grievance'] as int;
          _hearingCircle = element['total_vivad'] as int;
          break;
        case 2:
          _rejectedCitizen = element['total_grievance'] as int;
          _rejectedCircle = element['total_vivad'] as int;
          break;
        case 3:
          _closedCitizen = element['total_grievance'] as int;
          _closedCircle = element['total_vivad'] as int;
          break;
      }
    });
  }

  Future<void> _getWeekData() async {
    await Provider.of<StatusUpdateProvider>(context, listen: false)
        .countCaseStatus(_token, "", "week")
        .then((value) {
      setState(() {
        value.forEach((element) {
          _weekCitizen += element['total_grievance'] as int;
          _weekCircle += element['total_vivad'] as int;
        });
      });
    });
  }

  Future<void> _getMonthData() async {
    await Provider.of<StatusUpdateProvider>(context, listen: false)
        .countCaseStatus(_token, "", "month")
        .then((value) {
      setState(() {
        value.forEach((element) {
          _monthCitizen += element['total_grievance'] as int;
          _monthCircle += element['total_vivad'] as int;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    left: 2.5 * SizeConfig.widthMultiplier,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CaseStatusCards(
                            caseStatus: "Pending",
                            total: _pendingCircle + _pendingCitizen,
                            citizen: _pendingCitizen,
                            circle: _pendingCircle,
                            cardColor: CustomColors.kDarkOrange,
                          ),
                          SizedBox(
                            width: 1.5 * SizeConfig.widthMultiplier,
                          ),
                          CaseStatusCards(
                            caseStatus: "Hearing",
                            total: _hearingCircle + _hearingCitizen,
                            citizen: _hearingCitizen,
                            circle: _hearingCircle,
                            cardColor: CustomColors.kGreen,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          CaseStatusCards(
                            caseStatus: "Rejected",
                            total: _rejectedCircle + _rejectedCitizen,
                            citizen: _rejectedCitizen,
                            circle: _rejectedCircle,
                            cardColor: CustomColors.kRed,
                          ),
                          SizedBox(
                            width: 1.5 * SizeConfig.widthMultiplier,
                          ),
                          CaseStatusCards(
                            caseStatus: "Resolved",
                            total: _closedCircle + _closedCitizen,
                            citizen: _closedCitizen,
                            circle: _closedCircle,
                            cardColor: CustomColors.kBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                CustomTitle(title: "Recent Grievances"),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                BasicInformationList(
                  title: "Total Grievance",
                  total: _totalCitizenCount + _totalCircleCount,
                  citizen: _totalCitizenCount,
                  circle: _totalCircleCount,
                  icon: Icons.cases_rounded,
                  iconColor: CustomColors.kRed,
                  duration: "",
                ),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                BasicInformationList(
                  title: "Grievance during last month",
                  total: _monthCitizen + _monthCircle,
                  citizen: _monthCitizen,
                  circle: _monthCircle,
                  icon: Icons.calendar_month_rounded,
                  iconColor: CustomColors.kDarkYellow,
                  duration: "month",
                ),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                BasicInformationList(
                  title: "Grievance during last week",
                  total: _weekCitizen + _weekCircle,
                  citizen: _weekCitizen,
                  circle: _weekCircle,
                  icon: Icons.calendar_view_week_rounded,
                  iconColor: CustomColors.kGreen,
                  duration: "week",
                ),
                SizedBox(
                  height: 1.25 * SizeConfig.heightMultiplier,
                ),
              ],
            ),
          );
  }
}
