import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component/body.dart';

class VivadEntryScreen extends StatelessWidget {
  static const routeName = '/vivad_entry_screen';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    bool isEditMode = false;
    String vivad_uuid = '';

    if (routeArgs != null) {
      vivad_uuid = routeArgs['vivad_uuid'];
      isEditMode = routeArgs['isEditMode'];
    }

    // TODO: implement build

    return Scaffold(
      appBar: isEditMode
          ? _buildEditAppBar(context, vivad_uuid)
          : _buildAddAppBar(context),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: new Body(vivad_uuid, isEditMode),
      ),
    );
  }

  AppBar _buildEditAppBar(BuildContext buildContext, String vivad_uuid) {
    return AppBar(
      titleSpacing: 0.0,
      title: Text('Edit Registered Case'),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Tooltip(
            message: 'Delete Case',
            child: GestureDetector(
              onTap: () {
                _showAlertDialog('Delete', 'confirm to delete this Case !!!',
                    buildContext, vivad_uuid);
              },
              child: Icon(
                Icons.delete,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar _buildAddAppBar(BuildContext buildContext) {
    return AppBar(
      titleSpacing: 0.0,
      title: Text('New Case Registration'),
    );
  }

  void _showAlertDialog(
      String title, String message, BuildContext context, String vivad_uuid) {
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
            Provider.of<UploadVivadProvider>(context, listen: false)
                .deleteVivadData(vivad_uuid).then((_) => Navigator.of(context, rootNavigator: true).pop(context));
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
}
