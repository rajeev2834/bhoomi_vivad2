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
            padding: const EdgeInsets.all(16.0),
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 60),
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
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          'Thank You !!!',
                          style: TextStyle(
                            fontSize: 36,
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
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Grievance has been successfully ',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 16.0,
                                    )),
                                TextSpan(
                                  text:
                                      'registered through Bhoomi Vivad Tracker app',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Your Tracking id is: ',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              tracking_id,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.0))),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 20,
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
