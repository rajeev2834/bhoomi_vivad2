import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/screens/all_vivad/status_update_provider.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/size_config.dart';

class CircleWiseStatusScreen extends StatefulWidget {
  CircleWiseStatusScreen({
    Key? key,
    required this.caseStatus,
    required this.cardColor,
    required this.duration,
  }) : super(key: key);

  final String caseStatus;
  final Color cardColor;
  final String duration;

  @override
  _CircleWiseStatusScreenState createState() => _CircleWiseStatusScreenState();
}

class _CircleWiseStatusScreenState extends State<CircleWiseStatusScreen> {
  String _token = "";
  bool _isLoading = false;
  Color? _cardColor;
  String _caseStatus = "";
  String duration = "";

  List<Map<String, dynamic>> _circleWiseStatus = [];

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      _isLoading = true;
    });
    _cardColor = widget.cardColor;
    _caseStatus = widget.caseStatus;
    duration = widget.duration;
    _loadCircleWiseData(widget.caseStatus);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _loadCircleWiseData(String caseStatus) async {
    var provider = Provider.of<AddBaseData>(context, listen: false);
    await provider.getToken().then((value) async {
      _token = provider.token;
      await Provider.of<StatusUpdateProvider>(context, listen: false)
          .getCircleWiseStatus(_token, caseStatus, duration)
          .then((value) {
        setState(() {
          _circleWiseStatus = value;
          _circleWiseStatus
              .sort((a, b) => a['circle_id'].compareTo(b['circle_id']));
          _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? MySplashScreen()
        : Scaffold(
            appBar: _buildAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: _createDataTable(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  _buildAppBar() {
    var caseStatus = _caseStatus == ""
        ? "All"
        : int.parse(_caseStatus) == 0
            ? "Pending"
            : int.parse(_caseStatus) == 1
                ? "In Progress"
                : int.parse(_caseStatus) == 2
                    ? "Rejected"
                    : "Disposed";

    var title = duration == ""
        ? caseStatus
        : duration == "month"
            ? "Last Month"
            : "Last Week";

    return AppBar(
      title: Text(
        "$title Grievance",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: _cardColor,
      elevation: 0,
    );
  }

  DataTable _createDataTable() {
    return DataTable(
      columnSpacing: 2.5 * SizeConfig.widthMultiplier,
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
      DataColumn(label: Text('Circle')),
      DataColumn(label: Text('Citizen')),
      DataColumn(label: Text('Circle')),
      DataColumn(label: Text('Total')),
    ];
  }

  List<DataRow> _createRows() {
    return _circleWiseStatus.map((e) {
      return DataRow(
        cells: [
          DataCell(Text(
            e['circle_name'],
          )),
          DataCell(Text(
            e['total_grievance'].toString(),
          )),
          DataCell(Text(e['total_vivad'].toString())),
          DataCell(Text((e['total_grievance'] + e['total_vivad']).toString())),
        ],
      );
    }).toList();
  }
}
