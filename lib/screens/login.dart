import 'package:bhoomi_vivad/models/http_exception.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _authData = {
    'username': '',
    'password': '',
  };

  var _isLoading = false;
  var userRegex = r'^(?=[a-zA-Z0-9_]{6,10}$)(?![_]$)';
  var passRegex = r'^(?=[a-zA-Z0-9@#]{8,16}$)(?![@]$)';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: new Container(
            height: height,
            width: width,
            child: Padding(
                padding:
                    EdgeInsets.only(top: 3.75 * SizeConfig.heightMultiplier),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 1.25 * SizeConfig.heightMultiplier,
                            ),
                            Image.asset(
                              'assets/images/cm-image.png',
                              width: 12.5 * SizeConfig.heightMultiplier,
                              height: 12.5 * SizeConfig.heightMultiplier,
                            ),
                            Spacer(),
                            Image.asset(
                              'assets/images/bihar-govt.png',
                              width: 12.5 * SizeConfig.heightMultiplier,
                              height: 12.5 * SizeConfig.heightMultiplier,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.5 * SizeConfig.heightMultiplier,
                        ),
                        Image.asset(
                          'assets/images/BhoomiBank.png',
                          width: 18.75 * SizeConfig.heightMultiplier,
                          height: 18.75 * SizeConfig.heightMultiplier,
                        ),
                        SizedBox(
                          height: 2.5 * SizeConfig.heightMultiplier,
                        ),
                        Text(
                          'Bhoomi Vivad Tracker',
                          style: TextStyle(
                              fontSize: 3 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        SizedBox(
                          height: 2 * SizeConfig.heightMultiplier,
                        ),
                        Text(
                          'District Revenue Department, Nawada',
                          style: TextStyle(
                              fontSize: 2 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor),
                        ),
                        SizedBox(
                          height: 2.5 * SizeConfig.heightMultiplier,
                        ),
                        SizedBox(
                          height: 2.5 * SizeConfig.heightMultiplier,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 5 * SizeConfig.widthMultiplier,
                                right: 5 * SizeConfig.widthMultiplier),
                            child: TextFormField(
                              controller: userController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                RegExp regExp = RegExp(userRegex);
                                if (value!.isEmpty) {
                                  return 'Please enter username';
                                }
                                if (!regExp.hasMatch(value)) {
                                  return 'Invalid UserName';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['username'] = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'User Name',
                                labelStyle: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 2 * SizeConfig.heightMultiplier,
                                ),
                                prefixIcon: Icon(Icons.account_circle_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      2.5 * SizeConfig.heightMultiplier),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 1.9 * SizeConfig.heightMultiplier,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 2.5 * SizeConfig.heightMultiplier,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 5 * SizeConfig.widthMultiplier,
                                right: 5 * SizeConfig.widthMultiplier,
                                top: 1.25 * SizeConfig.heightMultiplier),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !_showPassword,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                RegExp regExp = RegExp(passRegex);
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (!regExp.hasMatch(value)) {
                                  return 'Invalid Password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 1.9 * SizeConfig.heightMultiplier),
                                prefixIcon: Icon(Icons.lock_sharp),
                                suffixIcon: IconButton(
                                  icon: Icon(_showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() => this._showPassword =
                                        !this._showPassword);
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      2.5 * SizeConfig.heightMultiplier),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 1.9 * SizeConfig.heightMultiplier,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 2.5 * SizeConfig.heightMultiplier,
                        ),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: EdgeInsets.all(
                                    1.25 * SizeConfig.heightMultiplier),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Builder(
                                        builder: (context) => ElevatedButton(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    right: 5 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 2.5 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _submit();
                                                  }
                                                });
                                              },
                                            )),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ))),
      ),
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
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<void> _submit() async {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signin(
        _authData['username'],
        _authData['password'],
      )
          .then((value) {
        Provider.of<Auth>(context, listen: false).fetchAndSetUser();
      });
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showAlertDialog('Error: ', errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not connect to the server. Please try again later !!!';
      _showAlertDialog('Error :', errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
