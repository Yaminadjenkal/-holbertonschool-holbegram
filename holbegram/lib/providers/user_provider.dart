import 'package:flutter/material.dart';

import '../methods/auth_methods.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  Users? _user;

  final AuthMethod _authMethod =
      AuthMethod();

  Users? get getUser => _user;

  Future<void> refreshUser() async {
    Users user =
        await _authMethod.getUserDetails();

    _user = user;

    notifyListeners();
  }
}