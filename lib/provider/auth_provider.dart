import 'package:flutter/material.dart';

import '../helper/auth_helper.dart';

class AuthProvider extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();
  bool _isLoggedIn = false;
  bool _isTosApproved = false;
  ConnectionState _state = ConnectionState.none;

  bool get isLoggedIn => _isLoggedIn;
  bool get isTosApproved => _isTosApproved;
  ConnectionState get state => _state;

  set tosValue(bool isApproved) {
    _isTosApproved = isApproved;
    notifyListeners();
  }

  Future<bool> getLoginStatus() async {
    _state = ConnectionState.active;

    try {
      _isLoggedIn = await _authHelper.getLoginStatus();

      if (_isLoggedIn) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future signWithPassword(String email, String pass) async {
    await _authHelper.signInwithPass(email, pass);
  }

  Future signWithGoogle() async {
    try {
      await _authHelper.signInWithGoogle();
    } catch (e) {
      throw 'Error while signing you in';
    }
  }

  Future registerWithEmail(String name, String email, String phone,
      String password, String birth, String gender) async {
    try {
      await _authHelper.registerEmail(
          name, email, phone, password, birth, gender);
    } catch (e) {
      throw 'Error while registering your account';
    }
  }
}
