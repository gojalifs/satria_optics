import 'package:flutter/material.dart';
import 'package:satria_optik/helper/user_helper.dart';
import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  final UserHelper _helper = UserHelper();
  UserProfile? _userProfile = UserProfile();

  UserProfile? get userProfile => _userProfile;

  void saveUser(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  Future getUser() async {}

  Future updateUser(Map<String, dynamic> userData) async {
    try {
      await _helper.updateUser(userData);
      Map<String, dynamic>? userMap = _userProfile?.toMap();

      Map<String, dynamic> newUserData = {...?userMap, ...userData};
      _userProfile = UserProfile.fromMap(newUserData);
    } finally {
      notifyListeners();
    }
  }

  void removeUser() {
    _userProfile = UserProfile();
    notifyListeners();
  }
}
