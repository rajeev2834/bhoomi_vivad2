import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entry_form.dart';

class Body extends StatelessWidget {
  Body(this.vivad_uuid, this.isEditMode);

  bool isEditMode;
  String vivad_uuid;

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
                EntryForm(
                  vivad_uuid: vivad_uuid,
                  isEditMode: isEditMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
