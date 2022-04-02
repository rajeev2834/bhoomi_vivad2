import 'package:bhoomi_vivad/screens/all_vivad/vivad_detail_list.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/addBaseData.dart';
import '../../providers/get_base_data.dart';

class CaseStatusArguments{
  final String status;
  CaseStatusArguments(this.status);
}

class VivadPendingScreen extends StatefulWidget {

  const VivadPendingScreen({Key? key}) : super(key: key);
  static const routeName = '/vivad_pending_screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _vivadPendingScreenState();
  }
}

class _vivadPendingScreenState extends State<VivadPendingScreen> {
  int? _userId;
  String? _circleId;
  bool _isLoaded = false;

  int _vivadCount = 0;

  _updateVivadCount(int vivadCount) {
    setState(() {
      _vivadCount = vivadCount;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoaded = true;
    });

    _getUserId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _getUserId() async {
    var provider = Provider.of<AddBaseData>(context, listen: false);
    await provider.getUserData().then((value) {
      _userId = provider.users[0].id;
      _getCircleList();
    });
  }

  Future<void> _getCircleList() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getCircleData(_userId!).then((value) {
      _circleId = provider.circles[0].circleId;
      setState(() {
        _isLoaded = false;
      });
    }).catchError((handleError) {
      if (handleError.toString().contains('Valid value range is empty')) {
        _showResultDialog(context, 'Error', 'Please download base data first');
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
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final args = ModalRoute.of(context)!.settings.arguments as CaseStatusArguments;
    return _isLoaded
        ? MySplashScreen()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: CustomTitle(title: args.status),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 5,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.people_alt),
                      text: 'Citizen Login',
                    ),
                    Tab(
                      icon: Icon(Icons.admin_panel_settings_rounded),
                      text: 'Circle Login',
                    ),
                  ],
                ),
                elevation: 20.0,
                titleSpacing: 20,
              ),
              body: TabBarView(
                children: [
                  pendingLists('Citizen', args.status),
                  pendingLists('Circle', args.status),
                ],
              ),
            ),
          );
  }

  Widget CustomTitle({required String title}) {
    var appBarTitle = title == "pending"
        ? "Pending Grievances"
        : title == "hearing"
            ? "Hearing Scheduled"
            : title == "rejected"
                ? "Rejected Grievances"
                : title == "disposed"
                    ? "Disposed Grievances"
                    : "";
    return Text(
      appBarTitle
    );
  }

  Widget pendingLists(String level, String status) {
    return VivadDetailList(
      status: status,
      level: level,
      circle: _circleId,
    );
  }
}
