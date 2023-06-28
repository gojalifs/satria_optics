import 'package:flutter/material.dart';
import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile = UserProfile();

  UserProfile? get userProfile => _userProfile;

  void saveUser(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void removeUser() {
    _userProfile = UserProfile();
    notifyListeners();
  }
}
