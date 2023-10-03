import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<List<String>> checkLoginMethod(String email) async {
    try {
      var data = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return data;
    } catch (e) {
      throw 'Error Happened';
    }
  }

  Future<UserCredential> signWithPassword(String email, String pass) async {
    state = ConnectionState.active;
    try {
      var credential = await _authHelper.signInwithPass(email, pass);

      return credential!;
    } catch (e) {
      rethrow;
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

  updatePassword(String? email, String oldPassword, String newPassword) async {
    state = ConnectionState.active;
    print('email$email');
    try {
      await signWithPassword(email!, oldPassword);
      await _authHelper.updatePassword(oldPassword, newPassword);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
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

  Future logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future unlinkGoogle() async {
    state = ConnectionState.active;

    try {
      await FirebaseAuth.instance.currentUser?.unlink("google.com");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "no-such-provider":
          throw 'No Provider Found. If error still occured, please contact admin';
        default:
          throw 'Unknown Error';
      }
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }
}
