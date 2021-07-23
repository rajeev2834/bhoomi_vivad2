import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDialog extends StatefulWidget {
  FilterDialog({
    Key? key,
    required bool this.showAll,
    required DateTime this.fromdate,
    required String this.fromdate_str,
    required DateTime this.todate,
    required String this.todate_str,
  }) : super(key: key);
  bool showAll;
  DateTime fromdate;
  DateTime todate;
  String todate_str;
  String fromdate_str;

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool showAll = true;
  DateTime fromdate = DateTime.now().subtract(Duration(days: 30));
  DateTime todate = DateTime.now();
  String todate_str = "";
  String fromdate_str = "";

  @override
  void initState() {
    showAll = widget.showAll;
    fromdate = widget.fromdate;
    todate = widget.todate;
    fromdate_str = widget.fromdate_str;
    todate_str = widget.todate_str;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Filter:"),
            TextButton(
              child: Text(showAll ? "ON" : "OFF"),
              onPressed: () {
                setState(() {
                  showAll = !showAll;
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("From-Date:"),
            TextButton(
              child: Text(fromdate_str),
              onPressed: showAll
                  ? null
                  : () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: fromdate,
                        firstDate: DateTime(1970),
                        lastDate: todate,
                      );
                      setState(() {
                        fromdate = (picked == null) ? fromdate : picked;
                        fromdate_str =
                            DateFormat('yyyy-MM-dd').format(fromdate);
                      });
                    },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("To-Date:"),
            TextButton(
              child: Text(todate_str),
              onPressed: showAll
                  ? null
                  : () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: todate,
                        firstDate: fromdate,
                        lastDate: DateTime.now(),
                      );
                      setState(() {
                        todate = (picked == null) ? todate : picked;
                        todate_str = DateFormat('yyyy-MM-dd').format(todate);
                      });
                    },
            ),
          ],
        ),
        Divider(
          thickness: 2,
          height: 1,
          endIndent: 0,
          indent: 0,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              VerticalDivider(
                thickness: 2,
                width: 1,
                endIndent: 0,
              ),
              TextButton(
                child: Text("Filter"),
                onPressed: () {
                  widget.showAll = true;
                  Navigator.of(context).pop({
                    'showAll': showAll,
                    'fromdate': fromdate,
                    'todate': todate,
                    'fromdate_str': fromdate_str,
                    'todate_str': todate_str,
                  });
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
