import 'package:bhoomi_vivad/models/panchayat.dart';
import 'package:bhoomi_vivad/screens/all_vivad/filter_dialog.dart';
import 'package:bhoomi_vivad/screens/all_vivad/help_funcs.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_list_screen.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'help_funcs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VivadReportScreen extends StatefulWidget {
  static const routeName = '/vivad_report_screen';

  @override
  _VivadReportScreenState createState() => _VivadReportScreenState();
}

class _VivadReportScreenState extends State<VivadReportScreen> {
  bool _sortNameAsc = true;
  bool _sortAgeAsc = true;
  bool _sortHightAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex = 0;
  List rows = [];
  DateTime fromdate = DateTime.now().subtract(Duration(days: 30));
  DateTime todate = DateTime.now();
  String todate_str = "";
  String fromdate_str = "";
  bool showAll = true;

  @override
  void initState() {
    fromdate_str = DateFormat('yyyy-MM-dd').format(fromdate);
    todate_str = DateFormat('yyyy-MM-dd').format(todate);
    getOpenClosed(true, "", "").then((value) => setState(() {
          rows = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Text("All Vivads"),
          actions: [
            TextButton.icon(
              icon: Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              label: Text(
                "Filter",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Map? output = await showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          child: FilterDialog(
                        showAll: showAll,
                        fromdate: fromdate,
                        todate: todate,
                        fromdate_str: fromdate_str,
                        todate_str: todate_str,
                      ));
                    });
                print(output);
                if (output == null) {
                  return;
                } else {
                  setState(() {
                    showAll = output["showAll"];
                    fromdate = output["fromdate"];
                    todate = output["todate"];
                    fromdate_str = output["fromdate_str"];
                    todate_str = output["todate_str"];
                  });
                  List _rows = rows =
                      await getOpenClosed(showAll, fromdate_str, todate_str);
                  setState(() {
                    rows = _rows;
                  });
                }
              },
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     List<Map<String, dynamic>> data;
        //     print(await getOpenClosed(true, "", ""));
        //     data = await DatabaseHelper.instance.queryAll('vivad');
        //     data.forEach((element) {
        //       print(element);
        //     });
        //   },
        // ),
        body: rows.isEmpty
            ? Center(child: Text("No Vivads Present"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAsc,
                          columns: [
                            DataColumn(
                              label: Text("Circle"),
                              onSort: (columnIndex, sortAscending) {
                                setState(() {
                                  if (columnIndex == _sortColumnIndex) {
                                    _sortAsc = _sortAgeAsc = sortAscending;
                                  } else {
                                    _sortColumnIndex = columnIndex;
                                    _sortAsc = _sortAgeAsc;
                                  }
                                  rows.sort((a, b) =>
                                      a['circle_id'].compareTo(b['circle_id']));
                                  if (!sortAscending) {
                                    rows = rows.reversed.toList();
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: Text("Panchayat"),
                              onSort: (columnIndex, sortAscending) {
                                setState(() {
                                  if (columnIndex == _sortColumnIndex) {
                                    _sortAsc = _sortAgeAsc = sortAscending;
                                  } else {
                                    _sortColumnIndex = columnIndex;
                                    _sortAsc = _sortAgeAsc;
                                  }
                                  rows.sort((a, b) => a['panchayat_id']
                                      .compareTo(b['panchayat_id']));
                                  if (!sortAscending) {
                                    rows = rows.reversed.toList();
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: Text("Open"),
                              numeric: true,
                              onSort: (columnIndex, sortAscending) {
                                setState(() {
                                  if (columnIndex == _sortColumnIndex) {
                                    _sortAsc = _sortAgeAsc = sortAscending;
                                  } else {
                                    _sortColumnIndex = columnIndex;
                                    _sortAsc = _sortAgeAsc;
                                  }
                                  rows.sort((a, b) =>
                                      a['pending'].compareTo(b['pending']));
                                  if (!sortAscending) {
                                    rows = rows.reversed.toList();
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: Text("Closed"),
                              numeric: true,
                              onSort: (columnIndex, sortAscending) {
                                setState(() {
                                  if (columnIndex == _sortColumnIndex) {
                                    _sortAsc = _sortAgeAsc = sortAscending;
                                  } else {
                                    _sortColumnIndex = columnIndex;
                                    _sortAsc = _sortAgeAsc;
                                  }
                                  rows.sort((a, b) =>
                                      a['closed'].compareTo(b['closed']));
                                  if (!sortAscending) {
                                    rows = rows.reversed.toList();
                                  }
                                });
                              },
                            )
                          ],
                          rows: rows.map((row) {
                            return DataRow(cells: [
                              DataCell(Text(row['circle_name_hn'])),
                              DataCell(Text(row['panchayat_name_hn'])),
                              DataCell(GestureDetector(
                                  child: Container(
                                      height: 35,
                                      width: 35,
                                      //color: Colors.grey,
                                      alignment: Alignment.center,
                                      child: Text(row['pending'].toString())),
                                  onTap: () {
                                    if (row['pending'] == 0) {
                                      return;
                                    }
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ListVivad(
                                          isClosed: false,
                                          circle_id: row['circle_id'],
                                          circle_name: row['circle_name_hn'],
                                          panchayat_id: row['panchayat_id'],
                                          panchayat_name:
                                              row['panchayat_name_hn'],
                                          showAll: showAll,
                                          fromdate: fromdate_str,
                                          todate: todate_str);
                                    }));
                                  })),
                              DataCell(GestureDetector(
                                  child: Container(
                                      height: 35,
                                      width: 35,
                                      alignment: Alignment.center,
                                      //color: Colors.grey,
                                      child: Text(row['closed'].toString())),
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if (row['closed'] == 0) {
                                      return;
                                    }
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ListVivad(
                                          isClosed: true,
                                          circle_id: row['circle_id'],
                                          circle_name: row['circle_name_hn'],
                                          panchayat_id: row['panchayat_id'],
                                          panchayat_name:
                                              row['panchayat_name_hn'],
                                          showAll: showAll,
                                          fromdate: fromdate_str,
                                          todate: todate_str);
                                    }));
                                  })),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }
}
