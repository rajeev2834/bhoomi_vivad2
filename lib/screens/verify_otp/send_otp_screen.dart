import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bhoomi_vivad/models/http_exception.dart';

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
              padding: const EdgeInsets.all(16.0),
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
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                            child: Image.asset(
                              'assets/images/BhoomiBank.png',
                              width: screenWidth * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text(
                              'Phone Number Verification',
                              style: TextStyle(
                                fontSize: 27,
                                color: Colors.black,
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
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(text: 'We will send you an ', style: TextStyle(color: Colors.indigo)),
                                    TextSpan(
                                        text: 'One Time Password ', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'on this mobile number', style: TextStyle(color: Colors.indigo)),
                                  ]),
                                ),
                            ),
                            Container(
                              height: 100,
                              constraints: const BoxConstraints(
                                  maxWidth: 500
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                              child: TextFormField(
                                controller: contactController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                maxLines: 1,
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  labelText: 'Enter Mobile No',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15.0),
                                  suffixIcon: Icon(Icons.phone_android_rounded,
                                      color: Colors.indigo),
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: validatePhone,
                                onSaved: (value) {
                                 _mobileData['phone_number'] = value;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              constraints: const BoxConstraints(
                                  maxWidth: 500
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(14.0))
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Send OTP',
                                        style: TextStyle(color: Colors.white, fontSize: 16.0,),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                          color: Colors.indigo,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onPressed: (){
                                  setState(() {
                                    if (_formKey.currentState!
                                        .validate()) {
                                      _generateOTP();
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),),
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
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return 'Please enter mobile no.';
    } else if (value.length != 10) {
      return 'Mobile no. must be of 10 digits';
    } else if (!regExp.hasMatch(value)) {
      return 'Mobile no. must be in digits';
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
      print("move to otp page");
      Navigator.of(context).pushNamed('/verify_otp');
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showAlertDialog('Error: ', errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not connect to the server. Please try again later !!!';
      _showAlertDialog('Error :', errorMessage);
    }
  }
}
