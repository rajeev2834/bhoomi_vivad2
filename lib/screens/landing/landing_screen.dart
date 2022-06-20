import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/grievance_status_screen.dart';
import 'package:bhoomi_vivad/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/size_config.dart';
import '../home_screen.dart';
import '../splash_screen.dart';
import 'header_widget.dart';

class Landing extends StatelessWidget {
  static const routeName = '/landing';
  double _headerHeight = 31 * SizeConfig.heightMultiplier;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        child: Image.asset(
          'assets/images/Nic_logo2-01.png',
          height: 5 * SizeConfig.heightMultiplier,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: _headerHeight,
              child: HeaderWidget(),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: <Widget>[
                    FittedBox(
                      child: Text(
                        'Bhoomi Vivad Tracker',
                        style: TextStyle(
                            fontSize: 3.75 * SizeConfig.heightMultiplier,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        'Register Bhoomi Vivad Case',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 2 * SizeConfig.heightMultiplier),
                      ),
                    ),
                    SizedBox(
                      height: 5 * SizeConfig.heightMultiplier,
                    ),
                    LandingScreenListView(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.help_outline_rounded),
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.of(context).pushNamed('/help');
        },
      ),
    );
  }

  Widget LandingScreenListView(BuildContext context) {
    List<ListViewItem> loadedItem = [
      ListViewItem(title: 'Citizen Grievnace', icon: Icons.people_alt_rounded),
      ListViewItem(
          title: 'Track Grievance', icon: Icons.pending_actions_rounded),
      ListViewItem(title: 'Admin Login', icon: Icons.admin_panel_settings),
    ];
    return Container(
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: [
            CardItemView(context, loadedItem[0], 0),
            SizedBox(
              height: 3.75 * SizeConfig.heightMultiplier,
            ),
            CardItemView(context, loadedItem[1], 1),
            SizedBox(
              height: 3.75 * SizeConfig.heightMultiplier,
            ),
            CardItemView(context, loadedItem[2], 2),
          ],
        ),
      ),
    );
  }

  Widget CardItemView(
      BuildContext context, ListViewItem loadedItem, int index) {
    return Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 10 * SizeConfig.heightMultiplier,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6),
          elevation: 1 * SizeConfig.heightMultiplier,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
          ),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
              child: Row(
                children: [
                  Icon(
                    loadedItem.icon,
                    size: 10 * SizeConfig.imageSizeMultiplier,
                    color: Colors.indigo,
                  ),
                  FittedBox(
                    child: Text(
                      loadedItem.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_sharp,
                    size: 5 * SizeConfig.imageSizeMultiplier,
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
            onTap: () async {
              _moveNextScreen(context, index);
            },
          ),
        ),
      ),
    );
  }

  void _moveNextScreen(BuildContext context, int index) async {
    if (index == 0) {
      Navigator.of(context).pushNamed('/otp_screen');
    } else if (index == 1) {
      return BottomSheetView(context);
    } else if (index == 2) {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => LoginToHome()));
    }
  }

  Future<dynamic> BottomSheetView(BuildContext buildContext) {
    final _trackingIdController = TextEditingController();
    String trackingId = '';
    return showModalBottomSheet(
        context: buildContext,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      'Please enter tracking id to see status',
                      style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: TextField(
                      maxLength: 16,
                      maxLines: 1,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: _trackingIdController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Theme.of(context).primaryColorDark,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Tracker Id',
                          prefixIcon: Icon(
                            Icons.sticky_note_2_rounded,
                            color: Colors.indigo,
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    constraints: BoxConstraints(maxWidth: 500),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                          14.0,
                        ))),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        RegExp _regExp = RegExp('[A-Z]{5}[0-9]{11}');
                        String value = _trackingIdController.text.toUpperCase();
                        if (value.isEmpty || value.length < 16) {
                          _showResultDialog(
                              context, '', 'Please enter valid Tracking Id');
                        } else if (!(value.startsWith('GR') ||
                            value.startsWith('CO'))) {
                          _showResultDialog(context, '',
                              'Tracking Id must starts with GR or CO');
                        } else if (!_regExp.hasMatch(value)){
                          _showResultDialog(context, '',
                              'Please enter valid Tracking Id');
                        }else {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => GrievanceStatus(
                                    trackingId: value,
                                  )));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
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
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

class ListViewItem {
  final String title;
  final IconData icon;

  ListViewItem({required this.title, required this.icon});
}

class LoginToHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<Auth>(
      builder: (ctx, auth, _) => auth.isAuth
          ? HomeScreen()
          : FutureBuilder(
              future: auth.autoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? MySplashScreen()
                      : Login(),
            ),
    );
  }
}
