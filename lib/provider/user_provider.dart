import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:satria_optik/helper/user_helper.dart';
import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  final UserHelper _helper = UserHelper();
  ConnectionState _state = ConnectionState.none;
  UserProfile? _userProfile = UserProfile();
  final ImagePicker picker = ImagePicker();
  XFile? _image;

  UserProfile? get userProfile => _userProfile;
  ConnectionState get state => _state;
  XFile? get image => _image;

  Future getUser() async {
    _state = ConnectionState.active;
    _userProfile = await _helper.getUserProfile();
    _state = ConnectionState.done;

    notifyListeners();
  }

  Future updateUser(Map<String, dynamic> userData) async {
    _state = ConnectionState.active;
    try {
      await _helper.updateUser(userData);
      Map<String, dynamic>? userMap = _userProfile?.toMap();

      Map<String, dynamic> newUserData = {...?userMap, ...userData};
      _userProfile = UserProfile.fromMap(newUserData);
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future updateAvatar() async {
    _state = ConnectionState.active;
    try {
      String? imageUrl = await _helper.updateAvatar(File(_image!.path));
      var user = _userProfile?.toMap();
      var newUser = {
        ...?user,
        ...{
          'avatarPath': imageUrl,
          'image': File(_image!.path),
        }
      };
      _userProfile = UserProfile.fromMap(newUser);
      _image = null;
    } catch (e) {
      throw 'Error when updating your avatar, $e';
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  void removeUser() {
    _userProfile = UserProfile();
    notifyListeners();
  }

  void removeImage() {
    _image = null;
    notifyListeners();
  }

  Future getPictCamera() async {
    final pict = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    var filePath = pict!.path;
    var targetPath = '${filePath}_compressed.jpg';
    var compressed = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 25,
    );

    _image = XFile(compressed!.path);
    notifyListeners();
  }

  Future getPictGallery() async {
    final pict = await picker.pickImage(source: ImageSource.gallery);
    var filePath = pict!.path;
    var targetPath = '${filePath}_compressed.jpg';
    var compressed = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 25,
    );

    _image = XFile(compressed!.path);
    notifyListeners();
  }
}
