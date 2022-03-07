import 'package:bhoomi_vivad/models/mobile_otp.dart';
import 'package:bhoomi_vivad/screens/verify_otp/verify_otp_provider.dart';
import 'package:bhoomi_vivad/utils/loading_dialog.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';

class VerifyOTPScreen extends StatefulWidget {
  static const routeName = '/verify_otp';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VerifyOTPScreen();
  }
}

class _VerifyOTPScreen extends State<VerifyOTPScreen> {
  String text = '';
  String phoneNumber = '';
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  MobileOTP? _mobileOTP;

  void _onKeyBoardTap(String value) {
    setState(() {
      if (text.length < 6) text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 5 * SizeConfig.heightMultiplier,
        width: 5 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(Radius.circular(1 * SizeConfig.heightMultiplier))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 5 * SizeConfig.heightMultiplier,
        width: 5 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(Radius.circular(1 * SizeConfig.heightMultiplier))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (routeArgs != null) {
      phoneNumber = routeArgs['phone_number'];
    }

    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Confirm'),
                  content: Text('Are you sure want to exit ?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          willLeave = true;
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        child: const Text('Exit')),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'))
                  ],
                ));
        return willLeave;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              margin:
                                   EdgeInsets.symmetric(horizontal: 5 * SizeConfig.widthMultiplier),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'Enter 6 digits OTP sent as SMS on ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 3.25 * SizeConfig.heightMultiplier,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                      text: phoneNumber,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 2 * SizeConfig.heightMultiplier,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: 125 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  otpNumberWidget(0),
                                  otpNumberWidget(1),
                                  otpNumberWidget(2),
                                  otpNumberWidget(3),
                                  otpNumberWidget(4),
                                  otpNumberWidget(5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:  EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 1.25 * SizeConfig.heightMultiplier),
                        constraints: BoxConstraints(maxWidth: 125 * SizeConfig.widthMultiplier),
                        child: ElevatedButton(
                          onPressed: () {
                            text.length == 6
                                ? _verifyOTP()
                                : _showToast(context, 'Invalid OTP');
                          },
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 2 * SizeConfig.heightMultiplier),
                                ),
                                Container(
                                  padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(2.5 * SizeConfig.heightMultiplier)),
                                    color: Colors.indigo,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 2 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      NumericKeyboard(
                        onKeyboardTap: _onKeyBoardTap,
                        textColor: Colors.indigo,
                        rightIcon: Icon(
                          Icons.backspace,
                          color: Colors.indigo,
                        ),
                        rightButtonFn: () {
                          setState(() {
                            if (text.length > 0)
                              text = text.substring(0, text.length - 1);
                          });
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOTP() async {
    _mobileOTP = new MobileOTP(phone_number: phoneNumber, otp: text);
    Dialogs.showLoadingDialog(context, _keyLoader);
    await Provider.of<VerifyOTPProvider>(context, listen: false)
        .verifyOTP(_mobileOTP!)
        .then((value) {
      Navigator.of(this.context, rootNavigator: true).pop();
      Navigator.of(context).pushNamed('/grievance_screen');
    }).catchError((handleError) {
      Navigator.of(this.context, rootNavigator: true).pop();
      if (handleError.toString().contains('SocketException')) {
        _showToast(context, 'Please check your Network and try again.');
      } else {
        _showToast(context, handleError.toString());
      }
    });
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
