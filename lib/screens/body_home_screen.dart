import 'package:bhoomi_vivad/color/custom_colors.dart';
import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/screens/admin_module/screens/admin_dashboard.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_pending_screen.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_summary_screen.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';

class Body extends StatelessWidget {
  bool isAdmin;
  final String title;

  Body({required this.isAdmin, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600));

    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            height: size.height * 0.2,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                  ),
                  height: size.height * 0.2 - 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: FutureBuilder(
                    future: Provider.of<AddBaseData>(context, listen: false)
                        .getUserData(),
                    builder: (ctx, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Consumer<AddBaseData>(builder: (ctx, addBaseData, _) {
                            if (addBaseData.users.length > 0) {
                              return Row(
                                children: <Widget>[
                                  Text(
                                    "Welcome,",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                  ),
                                  Text(
                                    addBaseData.users[0].firstName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  )
                                ],
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50.0,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.23),
                        ),
                      ],
                    ),
                    child: isAdmin
                        ? GestureDetector(
                            onTap: () {
                              print("Refresh");
                            },
                            child: Text(
                              "Dashboard",
                              style: TextStyle(
                                fontSize: 2.25 * SizeConfig.heightMultiplier,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : TextButton.icon(
                            icon: Icon(Icons.cloud_download_rounded),
                            label: Text(
                              "Download Base Data",
                              style: TextStyle(
                                  fontSize: 2 * SizeConfig.heightMultiplier),
                            ),
                            onPressed: () {
                              _addBaseData(context, pr);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          isAdmin
              ? Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: DashboardScreen(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTitle(
                      title: title,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: VivadRelatedGrid(context),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future<void> _addBaseData(BuildContext context, ProgressDialog pr) async {
    try {
      await pr.show();
      await Provider.of<AddBaseData>(context, listen: false)
          .getToken()
          .then((value) {
        pr.update(message: 'Loading Circle data');
        Provider.of<AddBaseData>(context, listen: false)
            .fetchAndSetCircle()
            .then((value) {
          pr.update(message: 'Loading Panchayat data');
          Provider.of<AddBaseData>(context, listen: false)
              .fetchAndSetPanchayat()
              .then((value) {
            pr.update(message: 'Loading Vivad Type data');
            Provider.of<AddBaseData>(context, listen: false)
                .fetchAndSetVivadType()
                .then((value) {
              pr.update(message: "All data loaded.");
              pr.hide().whenComplete(() => null);
            });
          });
          // ignore: invalid_return_type_for_catch_error
        }).catchError((handleError) => _showAlertDialog(
                context, 'Error', 'Failed to load base data.'));
      });
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showAlertDialog(context, 'Error', errorMessage);
    }
  }

  Widget VivadRelatedGrid(BuildContext context) {
    List<GridViewItem> loadedItem = [
      GridViewItem(
          title: 'Register New Case',
          icon: Icons.app_registration,
          color: Colors.indigo),
      GridViewItem(
          title: 'Pending Case',
          icon: Icons.pending_actions_rounded,
          color: Colors.orange),
      GridViewItem(
          title: 'In Process',
          icon: Icons.schedule_outlined,
          color: Colors.green),
      GridViewItem(
          title: 'Rejected', icon: Icons.close_sharp, color: Colors.redAccent),
      GridViewItem(
          title: 'Disposed',
          icon: Icons.restore_from_trash_rounded,
          color: Colors.blueGrey),
      GridViewItem(
          title: 'Summary', icon: Icons.receipt_rounded, color: Colors.pink),
    ];
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            shrinkWrap: true,
            children: List.generate(
              loadedItem.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    _moveNextScreen(context, index);
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            loadedItem[index].icon,
                            color: loadedItem[index].color,
                            size: 50.0,
                          ),
                          Text(
                            loadedItem[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void _moveNextScreen(BuildContext context, int index) async {
    if (index == 0) {
      await Navigator.of(context).pushNamed('/upload_vivad_screen');
    } else if (index == 1) {
      await Navigator.of(context).pushNamed(VivadPendingScreen.routeName,
          arguments: CaseStatusArguments("pending"));
    } else if (index == 2) {
      await Navigator.of(context).pushNamed(VivadPendingScreen.routeName,
          arguments: CaseStatusArguments("hearing"));
    } else if (index == 3) {
      await Navigator.of(context).pushNamed(VivadPendingScreen.routeName,
          arguments: CaseStatusArguments("rejected"));
    } else if (index == 4) {
      await Navigator.of(context).pushNamed(VivadPendingScreen.routeName,
          arguments: CaseStatusArguments("disposed"));
    } else if (index == 5) {
      await Navigator.of(context).pushNamed(VivadSummaryScreen.routeName);
    }
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
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
}

class GridViewItem {
  final String title;
  final IconData icon;
  final Color color;

  GridViewItem({required this.title, required this.icon, required this.color});
}

class CustomTitle extends StatelessWidget {
  final String title;

  CustomTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 18,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 1.9 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w700,
                color: CustomColors.kDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
