
import 'package:flutter/material.dart';

import 'component/body.dart';

class VivadEntryScreen extends StatelessWidget{
  static const routeName = '/vivad_entry_screen';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text("Bhoomi Vivad Entry"),
      ),
      body: new GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Body(),),
    );

  }

}