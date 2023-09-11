import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:satria_optik/provider/base_provider.dart';

import '../helper/auth_helper.dart';

class AuthProvider extends BaseProvider {
  final AuthHelper _authHelper = AuthHelper();
  bool _isTosApproved = false;

  bool get isTosApproved => _isTosApproved;

  set tosValue(bool isApproved) {
    _isTosApproved = isApproved;
    notifyListeners();
  }

  Future<String?> getLoginStatus() async {
    state = ConnectionState.active;

    try {
      user = await _authHelper.getLoginStatus();

      if (user != null && user!.uid.isNotEmpty) {
        return user?.uid;
      }
      return null;
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<UserCredential> signWithPassword(String email, String pass) async {
    state = ConnectionState.active;
    try {
      var credential = await _authHelper.signInwithPass(email, pass);
      return credential!;
    } catch (e) {
      throw 'Error. This Email Is Reserved';
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future signWithGoogle() async {
    try {
      await _authHelper.signInWithGoogle();
    } catch (e) {
      throw 'Error while signing you in';
    }
  }

  Future<UserCredential> registerWithEmail(String name, String email,
      String phone, String password, String birth, String gender) async {
    try {
      return await _authHelper.registerEmail(
          name, email, phone, password, birth, gender);
    } catch (e) {
      throw 'Error while registering your account';
    }
  }
}
