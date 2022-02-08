import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
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

  int _currentStep = 0;

  static GrievnaceData data = GrievnaceData();

  @override
  void initState() {
    super.initState();
    _getAndSetToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _getAndSetToken() async {
    var provider = Provider.of<GetApiData>(context, listen: false);
    await provider.checkAndSetToken().then((_) async {
      await provider.getToken().then((_) async {
        await provider.getCircleList().then((_) async {
          await provider.getVivadType();
        });
      });
    }).catchError((handleError) {
      _showResultDialog(context, 'Error', handleError.toString());
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
    _formKey.currentState!.save();


  }

  @override
  Widget build(BuildContext context) => GestureDetector(
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
              controlsBuilder: (BuildContext context, ControlsDetails details) {
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
                                      width: 20.0,
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
                                          width: 20.0,
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
            padding: EdgeInsets.all(10.0),
            child: CircleDropDown(context),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: PanchayatDropDown(context),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Parivadi Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Please enter Name' : null,
              onSaved: (value) {
                data._name = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Parivadi Father Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                data._fatherName = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: 'Parivadi Contact No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.phone, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: validatePhone,
              onSaved: (value) {
                data._contact = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLines: 5,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Parivadi Address',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                data._address = value;
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
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Vadi Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Please enter Name' : null,
              onSaved: (value) {
                data._partyName = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Vadi Father Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.person_add_alt, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Vadi Father Name' : null,
              onSaved: (value) {
                data._partyFatherName = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: 'Vadi Contact No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.phone, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: validatePhone,
              onSaved: (value) {
                data._partyContact = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 100,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Vadi Address',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Vadi Address' : null,
              onSaved: (value) {
                data._partyAddress = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
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
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Mauza',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.layers, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Mauza' : null,
              onSaved: (value) {
                data._mauza = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Khata No',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.menu_book, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Khata No' : null,
              onSaved: (value) {
                data._khata = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Khesra No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon:
                    Icon(Icons.library_books_rounded, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Khesra No' : null,
              onSaved: (value) {
                data._khesra = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Demand No.',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon:
                    Icon(Icons.wallet_membership_sharp, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                data._demand = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: 500,
              maxLines: 7,
              decoration: InputDecoration(
                labelText: 'Grievance Detail',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Grievance detail' : null,
              onSaved: (value) {
                data._grievnace = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  String? validatePhone(String? value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return 'Please enter contact no.';
    } else if (value.length != 10) {
      return 'Contact no. must be of 10 digits';
    } else if (!regExp.hasMatch(value)) {
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
      _getPanchayatList(data._circleValue!);
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
                value == null ? 'Circle value required' : null,
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
      child: Consumer<GetApiData>(
        builder: (ctx, getApiData, _) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.90,
          child: DropdownButtonFormField<String>(
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
            items: getApiData.vivadTypes
                .map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e.vivad_type_hn),
                    value: e.id.toString(),
                  ),
                )
                .toList(),
            onChanged: ((value) {
              _dropDownPanchayatSelected(value);
            }),
            validator: (value) => value == null ? 'Vivad Type required' : null,
          ),
        ),
      ),
    );
  }
}
