import 'dart:io';

import 'package:bhoomi_vivad/models/vivad_status.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/hearing_update_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HearingUpdateArguments {
  final VivadStatus _vivadStatus;
  final String _token;
  final int _user;

  HearingUpdateArguments(this._vivadStatus, this._token, this._user);
}

class HearingTimeLineScreen extends StatefulWidget {
  static const routeName = '/hearing_timeline_screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HearingTimeLineScreenState();
  }
}

class _HearingTimeLineScreenState extends State<HearingTimeLineScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as HearingUpdateArguments;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text("Action History"),
      ),
      body: showActionHistory(args),
    );
  }

  Widget showActionHistory(HearingUpdateArguments args) {
    return HearingActionHistory(
      vivadStatus: args._vivadStatus,
      token: args._token,
      user: args._user,
    );
  }
}

class HearingActionHistory extends StatefulWidget {
  final VivadStatus vivadStatus;
  final String token;
  final int user;

  HearingActionHistory({
    Key? key,
    required this.vivadStatus,
    required this.token,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HearingActionHistory();
}

class _HearingActionHistory extends State<HearingActionHistory> {
  bool _isLoading = false;
  String _token = "";
  int? _user;
  VivadStatus? _vivadStatus;

  @override
  void initState() {
    super.initState();

    _token = widget.token;
    _user = widget.user;
    _vivadStatus = widget.vivadStatus;

    setState(() {
      _isLoading = true;
    });

    _loadHearingData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadHearingData() async {
    var provider = Provider.of<HearingUpdateProvider>(context, listen: false);
    provider.getHearingData(_vivadStatus!.vivad_id).then((value) {
      setState() {
        _isLoading = false;
      }
    }).catchError((handleError) {
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
    return Container();
    // TODO: implement build
  }
}
