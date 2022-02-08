import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_screen.dart';
import '../splash_screen.dart';
import 'header_widget.dart';

class Landing extends StatelessWidget {
  static const routeName = '/landing';
  double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                    Text(
                      'Bhoomi Vivad Tracker',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Register Bhoomi Vivad Case',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    LandingScreenListView(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LandingScreenListView(BuildContext context) {
    List<ListViewItem> loadedItem = [
      ListViewItem(title: 'Citizen Grievnace', icon: Icons.people_alt_rounded),
      ListViewItem(title: 'Admin Login', icon: Icons.admin_panel_settings),
    ];
    return Container(
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: [
            CardItemView(context, loadedItem[0], 0),
            SizedBox(
              height: 30.0,
            ),
            CardItemView(context, loadedItem[1], 1),
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
        height: 80,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    loadedItem.icon,
                    size: 40.0,
                    color: Colors.indigo,
                  ),
                  Text(
                    loadedItem.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_sharp,
                    size: 20.0,
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
      Navigator.of(context).pushNamed('/grievance_screen');
    } else if (index == 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => LoginToHome()));
    }
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
                      : Login(),),
    );
  }
}
