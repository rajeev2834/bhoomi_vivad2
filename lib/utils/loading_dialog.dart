import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.indigo.withOpacity(0.8),
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(strokeWidth: 3, color: Colors.white,),
                        SizedBox(height: 20,),
                        Text("Please Wait....",style: TextStyle(color: Colors.white),)
                      ]),
                    )
                  ]));
        });
  }
}