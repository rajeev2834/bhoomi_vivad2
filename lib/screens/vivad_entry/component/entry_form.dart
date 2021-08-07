import 'package:bhoomi_vivad/models/plot_detail.dart';
import 'package:bhoomi_vivad/models/thana.dart';
import 'package:bhoomi_vivad/models/vivad.dart';
import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/providers/get_base_data.dart';
import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class EntryForm extends StatefulWidget {
  EntryForm({Key? key, required this.vivad_uuid, required this.isEditMode})
      : super(key: key);

  String vivad_uuid;
  bool isEditMode;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EntryFormState();
  }
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();

  String? _circleValue;
  String? _panchayatValue;
  String? _mauzaValue;
  String? _thanaValue;
  String? _plotType;
  String? _plotNature;
  String? isDisposed;
  String? _khata;
  String? _khesra;
  String? _rakwa;
  String? _chauhaddi;
  String? _abhidariName;
  String? _firstPartyName;
  String? _firstPartyPhone;
  String? _firstPartyAddress;
  String? _secondPartyName;
  String? _secondPartPhone;
  String? _secondPartyAddress;
  String? _vivadCause;
  String? _violenceDetails;
  String? _noticeOrder;
  String? _courtStatus;
  String? _hearingDate;
  String? _remarks;
  String? _caseStatus;
  int? _userId;

  bool isViolence = false;
  bool isFir = false;
  bool isCourtPending = false;

  DateTime? _dateTime;
  TextEditingController _dateTimeController = TextEditingController();

  PlotDetail? _plotDetail;
  Vivad? _vivadData;

  var uuid = Uuid();

  List vivads = [];

  bool isLoading = false;
  var _isInit = true;
  var _initValues = {
    'plot_uuid': '',
    'panchayat_id': '',
    'mauza_id': '',
    'thana_no': '',
    'khata_no': '',
    'khesra_no': '',
    'rakwa': '',
    'chauhaddi': '',
    'plot_type': '',
    'plot_nature': '',
    'abhidari': '',
    'first_party_name': '',
    'first_contact': '',
    'first_address': '',
    'second_party_name': '',
    'second_contact': '',
    'second_address': '',
    'vivad_cause': '',
    'is_violence': '',
    'violence_detail': '',
    'is_fir': '',
    'fir_notice': '',
    'is_courtpending': '',
    'court_status': '',
    'case_status': '',
    'next_hearing_date': '',
    'remarks': '',
  };

  @override
  void initState() {
    // TODO: implement initState
    _getUserId();
    _getThanaList();
    _getPlotType();
    _getPlotNature();

    _caseStatus = 'Pending';

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.isEditMode) {
        var vivad_uuid = widget.vivad_uuid;
        setState(() {
          isLoading = true;
        });
        var provider = Provider.of<UploadVivadProvider>(context, listen: false);
        provider.getVivadWithPlotDetail(vivad_uuid).then((_) {
          vivads = provider.editVivads;
          _circleValue = vivads[0]['circle_id'];
          _initValues = {
            'plot_uuid': vivads[0]['plot_uuid'],
            'panchayat_id': vivads[0]['panchayat_id'],
            'mauza_id': vivads[0]['mauza_id'].toString(),
            'thana_no': vivads[0]['thana_no'].toString(),
            'khata_no': vivads[0]['khata_no'],
            'khesra_no': vivads[0]['khesra_no'],
            'rakwa': vivads[0]['rakwa'].toString(),
            'chauhaddi': vivads[0]['chauhaddi'],
            'plot_type': vivads[0]['plot_type_id'].toString(),
            'plot_nature': vivads[0]['plot_nature_id'].toString(),
            'abhidari': vivads[0]['abhidari_name'],
            'first_party_name': vivads[0]['first_party_name'],
            'first_contact': vivads[0]['first_party_contact'],
            'first_address': vivads[0]['first_party_address'],
            'second_party_name': vivads[0]['second_party_name'],
            'second_contact': vivads[0]['second_party_contact'],
            'second_address': vivads[0]['second_party_address'],
            'vivad_cause': vivads[0]['cause_vivad'],
            'is_violence': vivads[0]['is_violence'].toString(),
            'violence_detail': vivads[0]['violence_detail'],
            'is_fir': vivads[0]['is_fir'].toString(),
            'fir_notice': vivads[0]['notice_order'],
            'is_courtpending': vivads[0]['is_courtpending'].toString(),
            'court_status': vivads[0]['court_status'],
            'case_status': vivads[0]['case_status'],
            'next_hearing_date': vivads[0]['next_date'],
            'remarks': vivads[0]['remarks'],
          };

          _thanaValue = _initValues['thana_no'];
          _plotNature = _initValues['plot_nature'];
          _plotType = _initValues['plot_type'];

          isViolence =
              int.parse(_initValues['is_violence']!) == 1 ? true : false;
          isFir = int.parse(_initValues['is_fir']!) == 1 ? true : false;
          isCourtPending =
              int.parse(_initValues['is_courtpending']!) == 1 ? true : false;
          _caseStatus = _initValues['case_status'];
          isDisposed = _caseStatus == 'Pending' ? 'No' : 'Yes';
          _dateTimeController.text = (_initValues['next_hearing_date']!.isEmpty
              ? ''
              : _initValues['next_hearing_date'])!;

          setState(() {
            isLoading = false;
          });
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 6.0,
                ),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: CustomTitle(title: 'Basic Details'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: CircleDropDown(context),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: PanchayatDropDown(context),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: MauzaDropDown(context),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: ThanaDropDown(context),
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 6.0,
                ),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: CustomTitle(title: 'Plot Details'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: PlotDetails(),
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 6.0,
                ),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: CustomTitle(title: 'Party Details'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: PartyDetails(),
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 6.0,
                ),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: CustomTitle(title: 'Case Details'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CaseDetails(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    // TODO: implement build
  }

  Widget CustomTitle({required String title}) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 18,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget CircleDropDown(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        top: 0.0,
      ),
      child: Consumer<GetBaseData>(
        builder: (ctx, getBaseData, _) => Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DropdownButtonFormField<String>(
                value: _circleValue,
                decoration: InputDecoration(
                  labelText: 'Circle *',
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: getBaseData.circles
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
          ],
        ),
      ),
    );
  }

  Future<void> _getUserId() async {
    var provider = Provider.of<AddBaseData>(context, listen: false);
    await provider.getUserData().then((value) {
      _userId = provider.users[0].id;
      _getCircleList();
    });
  }

  Future<void> _getCircleList() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getCircleData(_userId!);
  }

  void _dropDownCircleSelected(String? value) {
    setState(() {
      _panchayatValue = null;
      _circleValue = value;
      _getPanchayatList();
    });
  }

  Widget PanchayatDropDown(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        top: 0.0,
      ),
      child: Consumer<GetBaseData>(
        builder: (ctx, getBaseData, _) => Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DropdownButtonFormField<String>(
                value: _initValues['panchayat_id']!.isEmpty
                    ? _panchayatValue
                    : _initValues['panchayat_id'],
                decoration: InputDecoration(
                  labelText: 'Panchayat *',
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: getBaseData.panchayats
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
          ],
        ),
      ),
    );
  }

  void _dropDownPanchayatSelected(String? value) {
    setState(() {
      _mauzaValue = _initValues['mauza_id']!.isEmpty ? null : _initValues['mauza_id'];
      _panchayatValue = value;
     if(widget.isEditMode && _initValues['panchayat_id'] != _panchayatValue){
       _mauzaValue = null;
     }
      _getMauzaList();
    });
  }

  Future<void> _getPanchayatList() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getPanchayatData();
  }

  Future<void> _getMauzaList() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getMauzaData(_panchayatValue);
  }

  Widget MauzaDropDown(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        top: 2.0,
      ),
      child: Consumer<GetBaseData>(
        builder: (ctx, getBaseData, _) => Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DropdownButtonFormField<String>(
                value: _mauzaValue,
                decoration: InputDecoration(
                  labelText: 'Mauza*',
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: getBaseData.mauzas
                    .map(
                      (e) => DropdownMenuItem<String>(
                        child: Text(e.mauza_name_hn),
                        value: e.mauza_id.toString(),
                      ),
                    )
                    .toList(),
                onChanged: ((value) {
                  setState(() {
                    _mauzaValue = value;
                  });
                }),
                validator: (value) =>
                    value == null ? 'Mauza value required' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getThanaList() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getThanaData();
  }

  Widget ThanaDropDown(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        top: 2.0,
      ),
      child: Consumer<GetBaseData>(
        builder: (ctx, getBaseData, _) => Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DropdownButtonFormField<String>(
                value: _thanaValue,
                decoration: InputDecoration(
                  labelText: 'Thana ',
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: getBaseData.thanas
                    .map(
                      (e) => DropdownMenuItem<String>(
                        child: Text(e.thana_name_hn),
                        value: e.thana_id.toString(),
                      ),
                    )
                    .toList(),
                onChanged: ((value) {
                  setState(() {
                    _thanaValue = value;
                  });
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PlotDetails() {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        top: 2.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 2.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['khata_no'],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Khata No',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon:
                    Icon(Icons.menu_book_outlined, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                _khata = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['khesra_no'],
              decoration: InputDecoration(
                labelText: 'Khesra No',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon:
                    Icon(Icons.scatter_plot_outlined, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                _khesra = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['rakwa'],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Rakwa (in acre)',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.rule_outlined, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                _rakwa = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['chauhaddi'],
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Chauhaddi',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon: Icon(Icons.fence_outlined, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                _chauhaddi = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: PlotType(),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: PlotNature(),
          ),
        ],
      ),
    );
  }

  Future<void> _getPlotType() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getPlotTypeData();
  }

  Widget PlotType() {
    return Container(
      child: Consumer<GetBaseData>(
        builder: (ctx, getBaseData, _) => Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DropdownButtonFormField<String>(
                value: _plotType,
                decoration: InputDecoration(
                  labelText: 'Plot Type ',
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: getBaseData.plot_types
                    .map(
                      (e) => DropdownMenuItem<String>(
                        child: Text(e.plot_type),
                        value: e.id.toString(),
                      ),
                    )
                    .toList(),
                onChanged: ((value) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  setState(() {
                    _plotType = value;
                  });
                }),
                validator: (value) => value == null ? 'Select plot type' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getPlotNature() async {
    var provider = Provider.of<GetBaseData>(context, listen: false);
    await provider.getPlotNatureData();
  }

  Widget PlotNature() {
    return Container(
      child: Consumer<GetBaseData>(
        builder: (ctx, getBaseData, _) => Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DropdownButtonFormField<String>(
                value: _plotNature,
                decoration: InputDecoration(
                  labelText: 'Plot Nature ',
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: getBaseData.plot_nature
                    .map(
                      (e) => DropdownMenuItem<String>(
                        child: Text(e.plot_nature),
                        value: e.id.toString(),
                      ),
                    )
                    .toList(),
                onChanged: ((value) {
                  setState(() {
                    _plotNature = value;
                  });
                }),
                validator: (value) =>
                    value == null ? 'Select plot nature' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PartyDetails() {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        top: 2.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 2.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['abhidari'],
              decoration: InputDecoration(
                labelText: 'Abhidhari Name',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                _abhidariName = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['first_party_name'],
              decoration: InputDecoration(
                labelText: 'First Party Name',
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
                  value!.isEmpty ? 'Please enter First Party name' : null,
              onSaved: (value) {
                _firstPartyName = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['first_contact'],
              keyboardType: TextInputType.phone,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: 'First Party Contact No',
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
                _firstPartyPhone = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['first_address'],
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'First Party Address',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon:
                    Icon(Icons.streetview_outlined, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter First Party address' : null,
              onSaved: (value) {
                _firstPartyAddress = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['second_party_name'],
              decoration: InputDecoration(
                labelText: 'Second Party Name',
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
                  value!.isEmpty ? 'Please enter Second Party name' : null,
              onSaved: (value) {
                _secondPartyName = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['second_contact'],
              keyboardType: TextInputType.phone,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: 'Second Party Contact',
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
                _secondPartPhone = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['second_address'],
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Second Party Address',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                suffixIcon:
                    Icon(Icons.streetview_outlined, color: Colors.indigo),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter Second Party address' : null,
              onSaved: (value) {
                _secondPartyAddress = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget CaseDetails() {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        top: 2.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 2.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['vivad_cause'],
              decoration: InputDecoration(
                labelText: 'Cause of Vivad',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                _vivadCause = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 2.0,
              bottom: 5.0,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Is Violence happened',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.indigo,
                  ),
                ),
                Checkbox(
                  value: this.isViolence,
                  onChanged: (bool? value) {
                    setState(() {
                      this.isViolence = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          isViolence
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                    top: 10.0,
                    bottom: 5.0,
                  ),
                  child: TextFormField(
                    initialValue: _initValues['violence_detail'],
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Violence Details',
                      labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter violence details' : null,
                    onSaved: (value) {
                      _violenceDetails = value;
                    },
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 2.0,
              bottom: 5.0,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Is FIR filed',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.indigo,
                  ),
                ),
                Checkbox(
                  value: this.isFir,
                  onChanged: (bool? value) {
                    setState(() {
                      this.isFir = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          isFir
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                    top: 10.0,
                    bottom: 5.0,
                  ),
                  child: TextFormField(
                    initialValue: _initValues['fir_notice'],
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'FIR Notice Order',
                      labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter FIR details' : null,
                    onSaved: (value) {
                      _noticeOrder = value;
                    },
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 2.0,
              bottom: 5.0,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Is Case Pending in Court',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.indigo,
                  ),
                ),
                Checkbox(
                  value: this.isCourtPending,
                  onChanged: (bool? value) {
                    setState(() {
                      this.isCourtPending = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          isCourtPending
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                    top: 10.0,
                    bottom: 5.0,
                  ),
                  child: TextFormField(
                    initialValue: _initValues['court_status'],
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Court Case Status',
                      labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter court status' : null,
                    onSaved: (value) {
                      _courtStatus = value;
                    },
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 10.0,
              bottom: 0.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Is case closed ?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              top: 5.0,
              bottom: 5.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    value: 'Yes',
                    groupValue: isDisposed,
                    onChanged: (val) {
                      setState(() {
                        isDisposed = val as String?;
                        _caseStatus = 'Closed';
                      });
                    },
                    title: Text('Yes'),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: 'No',
                    groupValue: isDisposed,
                    onChanged: (val) {
                      setState(() {
                        isDisposed = val as String?;
                        _caseStatus = 'Pending';
                      });
                    },
                    title: Text('No'),
                  ),
                ),
              ],
            ),
          ),
          isDisposed == 'No'
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                    top: 10.0,
                    bottom: 5.0,
                  ),
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: _dateTimeController,
                        decoration: InputDecoration(
                          labelText: 'Next Hearing Date',
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.indigo,
                          ),
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.0),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter next hearing date'
                            : null,
                        onSaved: (value) {
                          _hearingDate = value;
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 10.0,
              bottom: 5.0,
            ),
            child: TextFormField(
              initialValue: _initValues['remarks'],
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Remaks, if any',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSaved: (value) {
                _remarks = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(
                    builder: (context) => ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_formKey.currentState!.validate()) {
                                _submit(context);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              } else {
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Some of the mandatory fields are blank !!!',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 5000),
                                  backgroundColor: Colors.red[900],
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        8.0, // Inner padding for SnackBar content.
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            });
                          },
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime(2222),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _dateTime = picked;
        _dateTimeController.text = DateFormat("dd-MM-yyyy").format(_dateTime!);
      });
  }

  Future<void> _submit(BuildContext context) async {
    _formKey.currentState!.save();
    try {
      var plot_uuid;
      var vivad_uuid;

      if (widget.isEditMode) {
        plot_uuid = _initValues['plot_uuid'];
        vivad_uuid = widget.vivad_uuid;
      } else {
        plot_uuid = uuid.v4();
        vivad_uuid = uuid.v4();
      }

      _plotDetail = new PlotDetail(
          plot_uuid: plot_uuid,
          chauhaddi: _chauhaddi ?? '',
          circle_id: _circleValue!,
          image: '',
          khata_no: _khata!,
          khesra_no: _khesra!,
          latitude: 0,
          longitude: 0,
          mauza_id: int.parse(
            _mauzaValue!,
          ),
          panchayat_id: _panchayatValue!,
          plot_nature_id: int.parse(_plotNature!),
          plot_type_id: int.parse(_plotType!),
          rakwa: double.parse(_rakwa!),
          remarks: _remarks ?? '',
          thana_no: '',
          is_govtPlot: 0);

      _vivadData = new Vivad(
          abhidari_name: _abhidariName ?? '',
          case_status: _caseStatus!,
          cause_vivad: _vivadCause ?? '',
          circle_id: _circleValue!,
          court_status: _courtStatus ?? '',
          first_party_address: _firstPartyAddress!,
          first_party_contact: _firstPartyPhone!,
          first_party_name: _firstPartyName!,
          is_courtpending: isCourtPending ? 1 : 0,
          is_fir: isFir ? 1 : 0,
          is_violence: isViolence ? 1 : 0,
          mauza_id: int.parse(_mauzaValue!),
          next_date: _hearingDate ?? '',
          notice_order: _noticeOrder ?? '',
          panchayat_id: _panchayatValue!,
          plot_uuid: plot_uuid,
          register_date: DateFormat("dd-MM-yyyy").format(DateTime.now()),
          remarks: _remarks ?? '',
          second_party_address: _secondPartyAddress!,
          second_party_contact: _secondPartPhone!,
          second_party_name: _secondPartyName!,
          thana_no: int.parse(_thanaValue!),
          violence_detail: _violenceDetails ?? '',
          vivad_uuid: vivad_uuid);

      ProgressDialog pr = new ProgressDialog(context);
      pr.style(
          message: 'Loading data...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w600));

      await pr.show();

      if (widget.isEditMode) {
        await Provider.of<UploadVivadProvider>(context, listen: false)
            .updatePlotDetail(_plotDetail!)
            .then((value) {
          pr.update(message: 'Updating data');
          Provider.of<UploadVivadProvider>(context, listen: false)
              .updateVivadData(_vivadData!)
              .then((value) {
            pr.hide().whenComplete(() => null);
            if (value == 1) {
              _showAlertDialog('Success', 'Data updated successfully');
            }else{
              _showAlertDialog('Failed', 'Data updation failed');
            }
            // ignore: invalid_return_type_for_catch_error
          }).catchError((handleError) {
            pr.hide().whenComplete(() => null);
            _showAlertDialog('Error', 'Failed to update plot data.');
          });
          // ignore: invalid_return_type_for_catch_error
        }).catchError((handleError) {
          pr.hide().whenComplete(() => null);
          _showAlertDialog('Error', 'Failed to save vivad data.');
        });
      } else {
        var result = await Provider.of<AddBaseData>(context, listen: false)
            .insertPlotData(_plotDetail!)
            .then((value) {
          pr.update(message: 'Saving data');
          Provider.of<AddBaseData>(context, listen: false)
              .insertVivadData(_vivadData!)
              .then((value) {
            pr.hide().whenComplete(() => null);
            _showAlertDialog('Success', 'Data saved successfully');
            _formKey.currentState?.reset();
            // ignore: invalid_return_type_for_catch_error
          }).catchError((handleError) {
            pr.hide().whenComplete(() => null);
            _showAlertDialog('Error', 'Failed to save plot data.');
          });
          // ignore: invalid_return_type_for_catch_error
        }).catchError((handleError) {
          pr.hide().whenComplete(() => null);
          _showAlertDialog('Error', 'Failed to save vivad data.');
        });
      }
    } catch (error) {
      _showAlertDialog('Submit Error :', error.toString());
    }
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
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
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
}
