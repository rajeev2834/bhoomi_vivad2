import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_provider.dart';
import 'package:bhoomi_vivad/screens/vivad_entry/vivad_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadVivadScreen extends StatefulWidget {
  static const routeName = '/upload_vivad_screen';

  @override
  _UploadVivadScreenState createState() => _UploadVivadScreenState();
}

class _UploadVivadScreenState extends State<UploadVivadScreen> {
  var count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text('New Vivad List'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Tooltip(
                message: 'Sync data',
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new IconButton(
                        onPressed: () {
                          _showAlertDialog(
                              'Sync data', 'Want to upload data on server ?');
                        },
                        icon: Icon(
                          Icons.cloud_upload,
                          size: 33.0,
                        )),
                    count != null
                        ? new Positioned(
                            top: 10,
                            right: 0,
                            child: new Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red[900],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          )
                        : new Container()
                  ],
                ),
              ),
            ),
          ],
        ),
        body: getVivadList(),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: 'Enter new vivad',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VivadEntryScreen()),
              ).then((_) => setState(() {}));
            }),
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
            'No',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/upload_vivad_screen');
            Provider.of<UploadVivadProvider>(context, listen: false).getToken().then((_){
              Provider.of<UploadVivadProvider>(context, listen: false).uploadVivadData();
            });
          },
          child: Text(
            'Yes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget getVivadList() {
    return FutureBuilder(
      future: Provider.of<UploadVivadProvider>(context, listen: false)
          .getListEnteredVivad(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<UploadVivadProvider>(
              builder: (ctx, uploadVivadProvider, _) {
              if (uploadVivadProvider.result.length == 0) {
                return Center(
                  child: Text('Please enter new vivad'),
                );
              } else {
                if (count == null ||
                    count < uploadVivadProvider.result.length || uploadVivadProvider.result.length == 0) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    setState(() {
                      count = uploadVivadProvider.result.length;
                    });
                  });
                }
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: uploadVivadProvider.result.length,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) => Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 6),
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Align(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
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
                                                uploadVivadProvider
                                                        .result[index]
                                                    ['panchayat_name_hn'],
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
                                                uploadVivadProvider
                                                        .result[index]
                                                    ['mauza_name_hn'],
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
                                      Text(
                                        'First Party Details :',
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
                                            uploadVivadProvider.result[index]
                                                    ['first_party_name'] +
                                                ',  Ph:',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1.0,
                                          ),
                                          Text(
                                            uploadVivadProvider.result[index]
                                                ['first_party_contact'],
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
                                        uploadVivadProvider.result[index]
                                            ['first_party_address'],
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
                                            uploadVivadProvider.result[index]
                                                    ['second_party_name'] +
                                                ',  Ph:',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            uploadVivadProvider.result[index]
                                                ['second_party_contact'],
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
                                        uploadVivadProvider.result[index]
                                            ['second_party_address'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  var vivad_uuid = uploadVivadProvider.result[index]['vivad_uuid'];
                                  await Navigator.of(context).pushNamed('/vivad_entry_screen', arguments: {
                                    'vivad_uuid': vivad_uuid,
                                    'isEditMode': true,
                                  },).then((_) => setState(() {}));
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
            }),
    );
  }
}
