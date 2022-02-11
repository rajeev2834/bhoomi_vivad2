import 'package:bhoomi_vivad/models/http_exception.dart';
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
                padding: EdgeInsets.only(top: 30.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              'assets/images/cm-image.png',
                              width: 100,
                              height: 100,
                            ),
                            Spacer(),
                            Image.asset(
                              'assets/images/bihar-govt.png',
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Image.asset(
                          'assets/images/BhoomiBank.png',
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Bhoomi Vivad Tracker',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'District Revenue Department, Nawada',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextFormField(
                              controller: userController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter username';
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
                                  fontSize: 15.0,
                                ),
                                prefixIcon: Icon(Icons.account_circle_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10.0),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !_showPassword,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
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
                                    fontSize: 15.0),
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
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Builder(
                                        builder: (context) => ElevatedButton(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, right: 20.0),
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
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
      await 
         Provider.of<Auth>(context, listen: false)
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
