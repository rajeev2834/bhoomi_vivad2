import 'package:bhoomi_vivad/models/user.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';

class AddBaseData with ChangeNotifier {

  final dbHelper = DatabaseHelper.instance;

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> getUserData() async {
    final userData = await dbHelper.queryAll('user');
    _users = userData
        .map(
          (item) => User(
        firstName: item['first_name'],
        id: item['id'],
      ),
    )
        .toList();
    notifyListeners();
  }
}