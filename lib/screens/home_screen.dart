import '../providers/auth.dart';
import './body_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      body: Body(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Image.asset("assets/images/bhoomi_bank.png"),
        onPressed: () {},
      ),
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: Text('Bhoomi Vivad'),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Tooltip(
            message: 'Logout',
            child: GestureDetector(
              onTap: () {
                _showAlertDialog('Logout', 'Are you really want to logout ?');
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

  void _showAlertDialog(String title, String message) {
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
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
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