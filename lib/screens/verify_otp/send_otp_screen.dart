import 'package:bhoomi_vivad/models/http_exception.dart';
import 'package:bhoomi_vivad/models/mobile_device.dart';
import 'package:bhoomi_vivad/screens/verify_otp/verify_otp_provider.dart';
import 'package:bhoomi_vivad/utils/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/size_config.dart';

class SendOTPScreen extends StatefulWidget {
  static const routeName = '/otp_screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SendOTPScreen();
  }
}

class _SendOTPScreen extends State<SendOTPScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  MobileDevice? _mobileDevice;

  TextEditingController contactController = TextEditingController();

  bool _isLoading = false;

  Map<String, dynamic> _mobileData = {
    'phone_number': '',
    'device_imei': '',
    'device_info': '',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
              height: screenHeight,
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin:  EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier,
                                vertical: 5 * SizeConfig.heightMultiplier),
                            child: Image.asset(
                              'assets/images/BhoomiBank.png',
                              width: screenWidth * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal:2.5 * SizeConfig.widthMultiplier),
                            child: FittedBox(
                              child: Text(
                                'Phone Number Verification',
                                style: TextStyle(
                                  fontSize: 3.5 * SizeConfig.heightMultiplier,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),),
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
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: 'We will send you an ',
                                    style: TextStyle(color: Colors.indigo)),
                                TextSpan(
                                    text: 'One Time Password ',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'on this mobile number',
                                    style: TextStyle(color: Colors.indigo)),
                              ]),
                            ),
                          ),
                          Container(
                            height: 12.5 * SizeConfig.heightMultiplier,
                            constraints: BoxConstraints(maxWidth: 125 * SizeConfig.widthMultiplier),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier,
                                vertical: 6.25 * SizeConfig.heightMultiplier),
                            child: TextFormField(
                              controller: contactController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              maxLines: 1,
                              maxLengthEnforcement:
                              MaxLengthEnforcement.enforced,
                              decoration: InputDecoration(
                                labelText: 'Enter Mobile No',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 2 * SizeConfig.heightMultiplier),
                                suffixIcon: Icon(Icons.phone_android_rounded,
                                    color: Colors.indigo),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 2.5 * SizeConfig.widthMultiplier),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                                ),
                              ),
                              validator: validatePhone,
                              onSaved: (value) {
                                _mobileData['phone_number'] = value;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier,
                                vertical: 1.25 * SizeConfig.heightMultiplier),
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1 * SizeConfig.heightMultiplier,
                                    horizontal: 2 * SizeConfig.widthMultiplier),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Send OTP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 2 * SizeConfig.heightMultiplier,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.25 * SizeConfig.heightMultiplier)),
                                        color: Colors.indigo,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 4 * SizeConfig.imageSizeMultiplier,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    _generateOTP();
                                  }
                                });
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
        ),
      ),
    );
  }

  String? validatePhone(String? value) {
    String pattern = r'(^[^0-5][\d]*$)';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value!) || value.length < 10) {
      return 'Please enter valid mobile no.';
    }
    return null;
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
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<void> _generateOTP() async {
    _formKey.currentState!.save();
    try {
      _mobileDevice = new MobileDevice(
          phone_number: _mobileData['phone_number'],
          device_info: '',
          device_imei: '');
      Dialogs.showLoadingDialog(context, _keyLoader);
      await Provider.of<VerifyOTPProvider>(context, listen: false)
          .uploadMobileData(_mobileDevice!)
          .then((value) {
        Navigator.of(this.context, rootNavigator: true).pop();
        Navigator.of(context).pushNamed('/verify_otp',
          arguments: {
            'phone_number' : _mobileData['phone_number'],
          },);
      }).catchError((handleError) {
        Navigator.of(this.context, rootNavigator: true).pop();
        if (handleError.toString().contains('SocketException')) {
          _showToast(context, 'Please check your Network and try again.');
        } else {
          _showToast(context, handleError.toString());
        }
      });
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showAlertDialog('Error: ', errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not connect to the server. Please try again later !!!';
      _showAlertDialog('Error :', errorMessage);
    }
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
