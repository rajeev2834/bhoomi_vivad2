import 'dart:async';

import 'package:bhoomi_vivad/models/grievance.dart';
import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/providers/get_base_data.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:bhoomi_vivad/utils/loading_dialog.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class GrievnaceData {
  String? _circleValue;
  String? _panchayatValue;
  String? _mauza;
  String? _name;
  String? _fatherName;
  String? _contact;
  String? _address;
  String? _partyName;
  String? _partyFatherName;
  String? _partyContact;
  String? _partyAddress;
  String? _khata;
  String? _khesra;
  String? _demand;
  String? _vivadType;
  String? _grievnace;
}

class GrievanceEntryScreen extends StatefulWidget {
  static const routeName = '/grievance_screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GrievanceEntryScreen();
  }
}

class _GrievanceEntryScreen extends State<GrievanceEntryScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  int _currentStep = 0;
  Grievance? _grievance;

  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController vadiController = TextEditingController();
  TextEditingController vadiFatherController = TextEditingController();
  TextEditingController vadiContactController = TextEditingController();
  TextEditingController vadiAddressController = TextEditingController();
  TextEditingController mauzaController = TextEditingController();
  TextEditingController khataController = TextEditingController();
  TextEditingController khesraController = TextEditingController();
  TextEditingController demandController = TextEditingController();
  TextEditingController grievanceController = TextEditingController();

  static GrievnaceData data = GrievnaceData();
  bool _isLoading = false;



  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _getAndSetToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    fatherNameController.dispose();
    addressController.dispose();
    contactController.dispose();
    vadiAddressController.dispose();
    vadiContactController.dispose();
    vadiController.dispose();
    vadiFatherController.dispose();
    mauzaController.dispose();
    khataController.dispose();
    khesraController.dispose();
    demandController.dispose();
    grievanceController.dispose();
    super.dispose();
  }

  void _clearTextField() {
    nameController.clear();
    fatherNameController.clear();
    addressController.clear();
    contactController.clear();
    vadiAddressController.clear();
    vadiContactController.clear();
    vadiFatherController.clear();
    vadiController.clear();
    mauzaController.clear();
    khataController.clear();
    khesraController.clear();
    demandController.clear();
    grievanceController.clear();

    setState(() {});
  }

  Future<void> _getAndSetToken() async {
    var provider = Provider.of<AddBaseData>(context, listen: false);
    await provider.checkAndSetToken().then((_) async {
      await provider.getToken().then((_) async {
        await provider.fetchAndSetCircle().then((_) async {
          await provider.fetchAndSetPanchayat().then((value) async {
            await provider.fetchAndSetVivadType().then((value) async {
              await Provider.of<GetApiData>(context, listen: false)
                  .getCircleList()
                  .then((value) async {
                await Provider.of<GetBaseData>(context, listen: false)
                    .getVivadTypeData()
                    .then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                });
              });
            });
          });
        });
      });
    }).catchError((handleError) {
      if (handleError.toString().contains('SocketException')) {
        _showResultDialog(
            context, 'Network Error', 'Check your Internet and try again !!!');
      } else {
        _showResultDialog(context, 'Error', handleError.toString());
      }
    });
  }

  void _showResultDialog(BuildContext context, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(title);
          },
          child: Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<void> _submit(BuildContext context) async {
    _grievance = new Grievance(
        circle: data._circleValue!,
        panchayat: int.parse(data._panchayatValue!),
        name: nameController.text,
        contact: contactController.text,
        father_name: fatherNameController.text,
        address: addressController.text,
        party_name: vadiController.text,
        party_father_name: vadiFatherController.text,
        party_contact: vadiContactController.text,
        party_address: vadiAddressController.text,
        mauza: mauzaController.text,
        vivad_type: int.parse(data._vivadType!),
        khesra_no: int.parse(khesraController.text),
        khata_no: int.parse(khataController.text),
        demand_no: demandController.text,
        vivad_reason: grievanceController.text);

    Dialogs.showLoadingDialog(context, _keyLoader);

    await Provider.of<GetApiData>(context, listen: false)
        .uploadGrievanceData(_grievance!)
        .then((value) {
          print(value);
      Navigator.of(this.context, rootNavigator: true).pop();
      _showResultDialog(
          context, 'Success', 'Grievance submitted successfully !!!');
      _formKey.currentState?.reset();
      _clearTextField();
      Navigator.of(context).pushNamed('/tracking_id',
        arguments: {
          'tracking_id' : value,
        },);
    }).catchError((handleError) {
      Navigator.of(this.context, rootNavigator: true).pop();
      _showResultDialog(context, 'Error', handleError.toString());
    });
  }

  @override
  Widget build(BuildContext context) => _isLoading
      ? MySplashScreen()
      : WillPopScope(
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
                              Provider.of<Auth>(context, listen: false)
                                  .logout();
                              willLeave = true;
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/'));
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
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Text(
                  "Post Your Grievnace here",
                  ),
                ),
              body: Form(
                key: _formKey,
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _currentStep == 0
                            ? TextButton(
                                onPressed: details.onStepContinue,
                                child: const Text(
                                  'NEXT',
                                ),
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.indigo,
                                ),
                              )
                            : _currentStep == 1
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: details.onStepCancel,
                                          child: const Text('BACK'),
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.indigo,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5 * SizeConfig.widthMultiplier,
                                        ),
                                        TextButton(
                                          onPressed: details.onStepContinue,
                                          child: const Text('NEXT'),
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.indigo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _currentStep >= 2
                                    ? Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: details.onStepCancel,
                                              child: const Text('BACK'),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: Colors.indigo,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5 * SizeConfig.widthMultiplier,
                                            ),
                                            TextButton(
                                              onPressed: details.onStepContinue,
                                              child: const Text('SAVE'),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: Colors.indigo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: details.onStepCancel,
                                        child: const Text('BACK'),
                                      ),
                      ],
                    );
                  },
                  type: StepperType.horizontal,
                  steps: getSteps(),
                  currentStep: _currentStep,
                  onStepContinue: () {
                    final isLastStep = _currentStep == getSteps().length - 1;
                    if (formKeys[_currentStep].currentState!.validate()) {
                      if (isLastStep) {
                        print("completed");
                        _submit(context);
                      } else {
                        setState(() => _currentStep += 1);
                      }
                    }
                  },
                  onStepCancel: () {
                    _currentStep == 0
                        ? null
                        : setState(() {
                            _currentStep -= 1;
                          });
                  },
                  onStepTapped: (int index) {
                    if (formKeys[_currentStep].currentState!.validate()) {
                      setState(() => _currentStep = index);
                    }
                  },
                ),
              ),
            ),
          ),
        );

  List<Step> getSteps() => [
        Step(
          isActive: _currentStep >= 0,
          state: StepState.indexed,
          title: Text('Parivadi'),
          content: AddressDetail(context),
        ),
        Step(
          isActive: _currentStep >= 1,
          title: Text('Vadi'),
          content: PartyDetail(context),
        ),
        Step(
            isActive: _currentStep >= 2,
            title: Text('Plot'),
            content: VivadDetail(context)),
      ];

  Widget AddressDetail(BuildContext context) {

    return Form(
      key: formKeys[0],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: CircleDropDown(context),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: PanchayatDropDown(context),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: nameController,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Parivadi Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.5 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Please enter Name' : null,
              onSaved: (value) {
                nameController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: fatherNameController,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Parivadi Father Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.5 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              onSaved: (value) {
                fatherNameController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: 'Parivadi Contact No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.phone, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: validatePhone,
              onSaved: (value) {
                contactController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: addressController,
              maxLines: 5,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Parivadi Address',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              onSaved: (value) {
                addressController.text = value.toString();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget PartyDetail(BuildContext context) {
    return Form(
      key: formKeys[1],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: vadiController,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Vadi Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Please enter Name' : null,
              onSaved: (value) {
                vadiController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: vadiFatherController,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Vadi Father Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              onSaved: (value) {
                vadiFatherController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: vadiContactController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: 'Vadi Contact No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.phone, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: validatePhoneCharacter,
              onSaved: (value) {
                vadiContactController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: vadiAddressController,
              maxLength: 100,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Vadi Address',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Vadi Address' : null,
              onSaved: (value) {
                vadiAddressController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: VivadTypeDropDown(context),
          ),
        ],
      ),
    );
  }

  Widget VivadDetail(BuildContext context) {
    return Form(
      key: formKeys[2],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: mauzaController,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Mauza',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.layers, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Mauza' : null,
              onSaved: (value) {
                mauzaController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: khataController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Khata No',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon: Icon(Icons.menu_book, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Khata No' : null,
              onSaved: (value) {
                khataController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: khesraController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Khesra No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon:
                    Icon(Icons.library_books_rounded, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Khesra No' : null,
              onSaved: (value) {
                khesraController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: demandController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Demand No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                suffixIcon:
                    Icon(Icons.wallet_membership_sharp, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              onSaved: (value) {
                demandController.text = value.toString();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
            child: TextFormField(
              controller: grievanceController,
              maxLength: 500,
              maxLines: 7,
              decoration: InputDecoration(
                labelText: 'Grievance Detail',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 1.9 * SizeConfig.heightMultiplier),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 0.6 * SizeConfig.heightMultiplier,
                        horizontal: 2.25 * SizeConfig.widthMultiplier),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Grievance detail' : null,
              onSaved: (value) {
                grievanceController.text = value.toString();
              },
            ),
          ),
        ],
      ),
    );
  }

  String? validatePhone(String? value) {
    String pattern = r'(^[6-9][\d]*$)';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value!) || value.length < 10) {
      return 'Please enter valid mobile no.';
    }
    return null;
  }

  String? validatePhoneCharacter(String? value) {
    String pattern = r'(^[6-9][\d]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value?.length == 0)
      return null;
    else if (value?.length != 10) {
      return 'Contact no. must be of 10 digits';
    } else if (!regExp.hasMatch(value!)) {
      return 'Contact no. must be in digits';
    }
    return null;
  }

  Widget CircleDropDown(BuildContext context) {
    return Container(
      child: Consumer<GetApiData>(
        builder: (ctx, getApiData, _) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.90,
          child: DropdownButtonFormField<String>(
            value: data._circleValue,
            decoration: InputDecoration(
              labelText: 'Circle *',
              contentPadding: EdgeInsets.all(10.0),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: getApiData.circles
                .map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e.circleNameHn),
                    value: e.circleId,
                  ),
                )
                .toList(),
            onChanged: ((value) {
              _dropDownCircleSelected(value);
            }),
            validator: (value) =>
                value == null ? 'Circle value required' : null,
          ),
        ),
      ),
    );
  }

  void _dropDownCircleSelected(String? value) {
    setState(() {
      data._circleValue = value;
      data._panchayatValue = null;
      _getPanchayatList(value!);
    });
  }

  void _getPanchayatList(String circleId) {
    var provider = Provider.of<GetApiData>(context, listen: false);
    provider.getPanchayatList(circleId);
  }

  Widget PanchayatDropDown(BuildContext context) {
    return Container(
      child: Consumer<GetApiData>(
        builder: (ctx, getApiData, _) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.90,
          child: DropdownButtonFormField<String>(
            value: data._panchayatValue,
            decoration: InputDecoration(
              labelText: 'Panchayat *',
              contentPadding: EdgeInsets.all(10.0),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: getApiData.panchayats
                .map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e.panchayat_name_hn),
                    value: e.panchayat_id.toString(),
                  ),
                )
                .toList(),
            onChanged: ((value) {
              _dropDownPanchayatSelected(value);
            }),
            validator: (value) =>
                value == null ? 'Panchayat value required' : null,
          ),
        ),
      ),
    );
  }

  void _dropDownPanchayatSelected(String? value) {
    setState(() {
      data._panchayatValue = value;
    });
  }

  Widget VivadTypeDropDown(BuildContext context) {
    return Container(
      child: Consumer<GetBaseData>(
        builder: (ctx, getBaseData, _) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.90,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: data._vivadType,
            decoration: InputDecoration(
              labelText: 'Vivad Type *',
              contentPadding: EdgeInsets.all(10.0),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: getBaseData.vivadTypes
                .map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e.vivad_type_hn),
                    value: e.id.toString(),
                  ),
                )
                .toList(),
            onChanged: ((value) {
              _dropDownVivadTypeSelected(value);
            }),
            validator: (value) => value == null ? 'Vivad Type required' : null,
          ),
        ),
      ),
    );
  }

  void _dropDownVivadTypeSelected(String? value) {
    setState(() {
      data._vivadType = value;
    });
  }
}
