import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../color/custom_colors.dart';
import '../../../providers/auth.dart';
import '../../body_home_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  static const routeName = '/admin_home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Body(
        isAdmin: true,
        title: "",
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Image.asset("assets/images/bhoomi_bank.png"),
        onPressed: () {},
      ),
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: Text(
        'Bhoomi Vivad Tracker',
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Tooltip(
            message: 'Logout',
            child: GestureDetector(
              onTap: () {
                _showAlertDialog(
                    'Logout', 'Are you really want to logout ?', context);
              },
              child: Icon(
                Icons.logout,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(String title, String message, BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'No',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            //Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout().then((_) {
              //Navigator.of(context).pop();
            });
          },
          child: Text(
            'Yes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
