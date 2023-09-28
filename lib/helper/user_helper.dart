import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../model/user.dart';
import 'firestore_helper.dart';

class UserHelper extends FirestoreHelper {
  Future createUser(UserProfile user, String uid) async {
    await db
        .collection('users')
        .doc(uid)
        .set(user.toMap())
        .onError((error, stackTrace) => throw '$error');
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      var userData = UserProfile();
      DocumentReference<Map<String, dynamic>> docRef;
      userId = FirebaseAuth.instance.currentUser?.uid;
      docRef = FirebaseFirestore.instance.collection("users").doc(userID);
      if (userID == null) {
        return null;
      }

      var data = await docRef.get();
      var dataMap = data.data();

      if (dataMap?['avatarPath'] != null) {
        var response = await http.get(Uri.parse(dataMap?['avatarPath']));
        var directory = await getTemporaryDirectory();
        var file = File('${directory.path}/image.jpg');
        await file.writeAsBytes(response.bodyBytes);
        dataMap?['image'] = file;
      }

      userData = UserProfile.fromMap(dataMap!);
      return userData;
    } catch (e, s) {
      debugPrint('$s');
      throw 'errror $e';
    }
  }

  Future updateUser(Map<String, dynamic> data) async {
    try {
      if (data.keys.contains('email')) {
        print('update email');
        final user = await FirebaseAuth.instance.authStateChanges().first;
        await user?.updateEmail(data['email']);
      }

      /// TODO make sure this fix
      var userRef = db.collection('users').doc(userID);
      await userRef.update(data);
    } catch (e) {
      if (e == 'requires-recent-login') {
        rethrow;
      }
      throw "Error updating document, $e";
    }
  }

  Future<String?> updateAvatar(File avatar) async {
    try {
      var userRef = db.collection('users').doc(userID);
      String? imageUrl;
      if (avatar.existsSync()) {
        var avatarRef = storageRef.child('avatar/').child('$userID');
        var snapshot = await avatarRef.putFile(avatar);
        imageUrl = await snapshot.ref.getDownloadURL();
        await userRef.update({'avatarPath': imageUrl});
      }
      return imageUrl;
    } catch (e) {
      throw 'Error updating your avatar, $e';
    }
  }

  Future connectWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          throw "The provider has already been linked to the user.";

        case "invalid-credential":
          throw "The provider's credential is not valid.";

        case "credential-already-in-use":
          throw "The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.";

        // See the API reference for the full list of error codes.
        default:
          throw "Unknown error.";
      }
    }
  }

  Future<bool> isPhoneUsernameUsed(String value, String key) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    if (key == 'phone') {
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: value)
          .get();
    } else if (key == 'username') {
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: value)
          .get();
    } else {
      return false;
    }

    return snapshot.docs.isNotEmpty;
  }
}
