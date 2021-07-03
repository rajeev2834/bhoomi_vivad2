import 'package:bhoomi_vivad/providers/addBaseData.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
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
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Consumer<AddBaseData>(
                                builder: (ctx, addBaseData, _) => Row(
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
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
          CustomTitle(
            title: 'Bhoomi Vivad Related',
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, top: 10.0),
            child: VivadRelatedGrid(),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget CustomTitle({required String title}) {
    return Container(
      height: 18,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget VivadRelatedGrid() {
    List<GridViewItem> loadedItem = [
      GridViewItem(title: 'New Vivad Entry', icon: Icons.assignment),
      GridViewItem(title: 'Edit Vivad', icon: Icons.edit),
      GridViewItem(title: 'Pending Vivad', icon: Icons.pending_actions),
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
                   _moveNextScreen(index);
                  },
                      child: Card(
                        elevation: 5.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                loadedItem[index].icon,
                                color: Colors.indigo,
                                size: 33.0,
                              ),
                              Text(
                                loadedItem[index].title,
                                style: TextStyle(
                                  fontSize: 12.0,
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

  void _moveNextScreen(int index){
    print(index);
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

  GridViewItem({required this.title, required this.icon});
}
