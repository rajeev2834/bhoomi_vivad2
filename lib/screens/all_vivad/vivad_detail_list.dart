import 'package:bhoomi_vivad/models/vivad_status.dart';
import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/screens/all_vivad/status_update_screen.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VivadDetailList extends StatefulWidget {
  final String status;
  final String level;
  final String? circle;

  VivadDetailList({
    Key? key,
    required this.status,
    required this.level,
    required this.circle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VivadDetailList();
}

class _VivadDetailList extends State<VivadDetailList> {
  bool _isLoading = false;
  List<VivadStatus> vivads = [];
  String _token = "";

  TextEditingController _statusController = TextEditingController();
  TextEditingController _levelController = TextEditingController();
  TextEditingController _circleController = TextEditingController();

  DateFormat formatter = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _statusController.text = widget.status;
    _levelController.text = widget.level;
    _circleController.text = widget.circle!;
    setState(() {
      _isLoading = true;
    });

    _loadVivadList();
  }

  Future<void> _loadVivadList() async {
    var provider = Provider.of<AddBaseData>(context, listen: false);
    await provider.getToken().then((value) {
      _token = provider.token;
      provider
          .getVivadData(_statusController.text, _levelController.text,
              _circleController.text)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((handleError) {
        if (handleError.toString().contains('SocketException')) {
          _showResultDialog(
              context, 'Error', 'Please check your network connection !!!');
        } else {
          _showResultDialog(context, 'Error', handleError.toString());
        }
      });
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
    showDialog(context: context, builder: (_) => alertDialog).then((value) {
      if (value.toString().contains('Error')) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _statusController.dispose();
    _levelController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return _isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Consumer<AddBaseData>(builder: (ctx, addBaseData, _) {
            if (addBaseData.vivadStatusList.vivads.length == 0) {
              return Center(
                child: Text('There is no data to show.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    )),
              );
            } else {
              var count = addBaseData.vivadStatusList.vivads.length;
              vivads = addBaseData.vivadStatusList.vivads;
              return Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(1.25 * SizeConfig.heightMultiplier),
                    child: Text(
                      'Total: $count Cases',
                      style: TextStyle(
                        fontSize: 2.0 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: count,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) => Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: Align(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 10.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 2.0,
                                              ),
                                              child: Text(
                                                (index + 1).toString() + ".",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                ' Panchayat',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                vivads[index].panchayat,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Mauza',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                vivads[index].mauza,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.red,
                                        thickness: 2.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'First Party Details :',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            formatter
                                                .format(DateTime.parse(
                                                    vivads[index].created_date))
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Wrap(
                                        children: [
                                          Text(
                                            vivads[index].first_party_name +
                                                ',  Ph:',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1.0,
                                          ),
                                          Text(
                                            vivads[index].first_party_contact,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        vivads[index].first_party_address,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Second Party Details :',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Wrap(
                                        children: [
                                          Text(
                                            vivads[index].second_party_name +
                                                ',  Ph:',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            vivads[index].second_party_contact,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        vivads[index].second_party_address,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Vivad Reason :',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        vivads[index].vivad_type,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                _statusController.text == "pending"
                                    ? await Navigator.of(context)
                                        .pushNamed(
                                          StatusUpdateScreen.routeName,
                                          arguments: StatusUpdateArguments(
                                              vivads[index], _token),
                                        )
                                        .then((value) => setState(() {
                                              if (value == 0) {
                                                _isLoading = true;
                                                _loadVivadList();
                                              }
                                            }))
                                    : null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          });
  }
}
