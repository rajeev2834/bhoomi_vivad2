import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/size_config.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/help';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text("Help"),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(0.625 * SizeConfig.heightMultiplier),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding:
                EdgeInsets.only(bottom: 1.75 * SizeConfig.heightMultiplier),
            child: HelpScreenListView(context),
          ),
        ),
      ),
    );
  }

  Widget HelpScreenListView(BuildContext context) {
    List<ListViewItem> loadedItem = [
      ListViewItem(
          title: 'Terms & Privacy Policy', icon: Icons.sticky_note_2_outlined),
    ];
    return Container(
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: [
            CardItemView(context, loadedItem[0], 0),
            SizedBox(
              height: 3.75 * SizeConfig.heightMultiplier,
            ),
          ],
        ),
      ),
    );
  }

  Widget CardItemView(
      BuildContext context, ListViewItem loadedItem, int index) {
    return Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 10 * SizeConfig.heightMultiplier,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6),
          elevation: 1 * SizeConfig.heightMultiplier,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(1.25 * SizeConfig.heightMultiplier),
          ),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
              child: Row(
                children: [
                  Icon(
                    loadedItem.icon,
                    size: 10 * SizeConfig.imageSizeMultiplier,
                    color: Colors.indigo,
                  ),
                  FittedBox(
                    child: Text(
                      loadedItem.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_sharp,
                    size: 5 * SizeConfig.imageSizeMultiplier,
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
            onTap: () async {
              _moveNextScreen(context, index);
            },
          ),
        ),
      ),
    );
  }

  void _moveNextScreen(BuildContext context, int index) async {
    if (index == 0) {
      print('Terms & Privacy Policy');
      const url = 'https://nawada.nic.in/privacy/';
      _launchUrl(url);
    }
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false);
    } else {
      throw 'Unable to launch $url';
    }
  }
}

class ListViewItem {
  final String title;
  final IconData icon;

  ListViewItem({required this.title, required this.icon});
}
