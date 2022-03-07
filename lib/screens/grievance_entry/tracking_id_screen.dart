import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/material.dart';

class TrackingIdScreen extends StatelessWidget {
  static const routeName = '/tracking_id';
  String tracking_id = '';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (routeArgs != null) {
      tracking_id = routeArgs['tracking_id'];
    }
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
            height: screenHeight,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 7.5 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                        ),
                        child: Image.asset(
                          'assets/images/success.png',
                          width: screenWidth * 0.3,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.5 * SizeConfig.widthMultiplier),
                        child: Text(
                          'Thank You !!!',
                          style: TextStyle(
                            fontSize: 4.5 * SizeConfig.heightMultiplier,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 125 * SizeConfig.widthMultiplier,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 2.5 * SizeConfig.widthMultiplier),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Grievance has been successfully ',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 2 * SizeConfig.heightMultiplier,
                                    )),
                                TextSpan(
                                  text:
                                      'registered through Bhoomi Vivad Tracker app',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 2 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 2.5 * SizeConfig.widthMultiplier,
                          vertical: 3.75 * SizeConfig.heightMultiplier,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Your Tracking id is: ',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 2.1 * SizeConfig.heightMultiplier,
                              ),
                            ),
                            Text(
                              tracking_id,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 2.1 * SizeConfig.heightMultiplier,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 3.75 * SizeConfig.heightMultiplier),
                        constraints: BoxConstraints(maxWidth: 125 * SizeConfig.widthMultiplier),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1.75 * SizeConfig.heightMultiplier))),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1 * SizeConfig.heightMultiplier,
                                horizontal: 2 * SizeConfig.widthMultiplier),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 2.5 * SizeConfig.heightMultiplier,
                              ),
                            ),
                          ),
                          onPressed: () {
                            _showResultDialog(
                                context, 'Exit', 'Have you noted Tracking id?');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, String title, String message) {
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Text(
            'Yes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
