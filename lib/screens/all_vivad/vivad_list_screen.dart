import 'package:bhoomi_vivad/screens/all_vivad/help_funcs.dart';
import 'package:flutter/material.dart';

class ListVivad extends StatefulWidget {
  ListVivad(
      {Key? key,
      required this.isClosed,
      required this.panchayat_id,
      required this.panchayat_name,
      required this.showAll,
      required this.fromdate,
      required this.todate})
      : super(key: key);
  bool isClosed;
  String panchayat_id;
  String panchayat_name;
  bool showAll;
  String fromdate;
  String todate;

  @override
  _ListVivadState createState() => _ListVivadState();
}

class _ListVivadState extends State<ListVivad> {
  List vivads = [];
  List vivadsFiltered = [];
  int _sortColumnIndex = 6; //Register date
  bool _sortAsc = true;
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  @override
  void initState() {
    // TODO: implement initState
    getVivads(widget.panchayat_id, widget.isClosed, widget.showAll,
            widget.fromdate, widget.todate)
        .then((value) => setState(() {
              vivads = value;
              vivadsFiltered = vivads;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${vivads[0]['circle_name_hn']}, ${widget.panchayat_name} (${widget.isClosed ? 'Closed' : 'Open'})"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        getVivads('009', false, true, "", "");
      }),
      body: Column(
        children: [
          Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      _searchResult = value;
                      vivadsFiltered = vivads
                          .where((vivad) =>
                              vivad['mauza_name_hn'].contains(_searchResult) ||
                              vivad['first_party_name']
                                  .contains(_searchResult) ||
                              vivad['first_party_contact']
                                  .contains(_searchResult) ||
                              vivad['second_party_name']
                                  .contains(_searchResult) ||
                              vivad['second_party_contact']
                                  .contains(_searchResult) ||
                              vivad['register_date'].contains(_searchResult) ||
                              vivad['cause_vivad'].contains(_searchResult))
                          .toList();
                    });
                  }),
              trailing: new IconButton(
                icon: new Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    controller.clear();
                    _searchResult = '';
                    vivadsFiltered = vivads;
                  });
                },
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAsc,
                columns: [
                  DataColumn(
                    label: Text("Mauza"),
                    onSort: (columnIndex, sortAscending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = sortAscending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = sortAscending;
                        }
                        vivadsFiltered.sort(
                            (a, b) => a['mauza_id'].compareTo(b['mauza_id']));
                        if (!sortAscending) {
                          vivadsFiltered = vivadsFiltered.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: Text("First Party"),
                    onSort: (columnIndex, sortAscending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = sortAscending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = sortAscending;
                        }
                        vivadsFiltered.sort((a, b) => a['first_party_name']
                            .compareTo(b['first_party_name']));
                        if (!sortAscending) {
                          vivadsFiltered = vivadsFiltered.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: Text("Second Party"),
                    onSort: (columnIndex, sortAscending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = sortAscending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = sortAscending;
                        }
                        vivadsFiltered.sort((a, b) => a['second_party_name']
                            .compareTo(b['second_party_name']));
                        if (!sortAscending) {
                          vivadsFiltered = vivadsFiltered.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(label: Text("Khata")),
                  DataColumn(label: Text("Khesra")),
                  DataColumn(label: Text("Rakwa")),
                  DataColumn(
                    label: Text("Registered Date"),
                    onSort: (columnIndex, sortAscending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = sortAscending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = sortAscending;
                        }
                        vivadsFiltered.sort((a, b) =>
                            a['register_date'].compareTo(b['register_date']));
                        if (!sortAscending) {
                          vivadsFiltered = vivadsFiltered.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(label: Text("Vivad Cause"))
                ],
                rows: vivadsFiltered.map((row) {
                  return DataRow(cells: [
                    DataCell(Text(row['mauza_name_hn'] ?? "")),
                    DataCell(Text(row['first_party_name'] +
                        "\nPh: ${row['first_party_contact']}")),
                    DataCell(Text(row['second_party_name'] +
                        "\nPh: ${row['second_party_contact']}")),
                    DataCell(Text(row['khata_no'] ?? "")),
                    DataCell(Text(row['khesra_no'] ?? "")),
                    DataCell(Text(row['rakwa'].toString())),
                    DataCell(Text(row['register_date'] ?? "")),
                    DataCell(Text(row['cause_vivad'] ?? "")),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
