import 'package:flutter/material.dart';

import 'entry_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: RawScrollbar(
          thumbColor: Colors.indigoAccent,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                EntryForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
