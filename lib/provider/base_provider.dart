import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  User? _user;
  ConnectionState _state = ConnectionState.none;

  User? get user {
    return _user;
  }

  ConnectionState get state => _state;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  set state(ConnectionState state) {
    _state = state;
    notifyListeners();
  }
}
