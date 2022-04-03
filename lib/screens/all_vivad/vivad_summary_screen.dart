import 'package:bhoomi_vivad/screens/all_vivad/status_update_provider.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/addBaseData.dart';
import '../../providers/get_base_data.dart';

class VivadSummaryScreen extends StatefulWidget {
  static const routeName = '/vivad_summary_screen';

  @override
  _VivadSummaryScreenState createState() => _VivadSummaryScreenState();
}

class _VivadSummaryScreenState extends State<VivadSummaryScreen> {
  int? _userId;
  String? _circleId;
  bool _isLoaded = false;
  String? _token;

  List<Map<String, dynamic>> _caseStatusCount = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoaded = true;
    });
    _getUserId();
  }

  Future<void> _getUserId() async {
    var provider = Provider.of<AddBaseData>(context, listen: false);
    await provider.getToken().then((value) {
      _token = provider.token;
      provider.getUserData().then((value) {
        _userId = provider.users[0].id;
        _getCircleList();
      });
    });
  }

  Future<void> _getCircleList() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getCircleData(_userId!).then((value) {
      _circleId = provider.circles[0].circleId;
      _loadCaseStatusSummary();
    }).catchError((handleError) {
      setState(() {
        _isLoaded = false;
      });
      if (handleError.toString().contains('Valid value range is empty')) {
        _showResultDialog(context, 'Error', 'Please download base data first');
      } else {
        _showResultDialog(context, 'Error', handleError.toString());
      }
    });
  }

  Future<void> _loadCaseStatusSummary() async {
    var provider = Provider.of<StatusUpdateProvider>(context, listen: false);
    await provider.countCaseStatus(_token, _circleId!).then((value) {
      setState(() {
        _isLoaded = false;
        _caseStatusCount = value;
      });
    }).catchError((handleError) {
      setState(() {
        _isLoaded = false;
      });
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
    // TODO: implement build
    return _isLoaded
        ? MySplashScreen()
        : Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Text('Case Status Summary'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _createDataTable()),
                  ),
                ),
              ],
            ),
          );
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      dividerThickness: 3,
      dataRowHeight: 10 * SizeConfig.heightMultiplier,
      showBottomBorder: true,
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 1.75 * SizeConfig.heightMultiplier,
      ),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.black),
      dataTextStyle: TextStyle(
        fontSize: 1.9 * SizeConfig.heightMultiplier,
        color: Colors.black,
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Case Status')),
      DataColumn(label: Text('Citizen Login')),
      DataColumn(label: Text('Circle Level'))
    ];
  }

  List<DataRow> _createRows() {
    return _caseStatusCount
        .map((e) => DataRow(cells: [
              DataCell(Text(e['case_status'] == 0
                  ? 'Pending'
                  : e['case_status'] == 1
                      ? 'In Process'
                      : e['case_status'] == 2
                          ? 'Rejected'
                          : e['case_status'] == 3
                              ? 'Disposed'
                              : '')),
              DataCell(Text(e['total_grievance'].toString())),
              DataCell(Text(e['total_vivad'].toString())),
            ]))
        .toList();
  }
}
