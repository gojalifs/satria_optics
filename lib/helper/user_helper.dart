import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/helper/firestore_helper.dart';

import '../model/user.dart';
import '../provider/user_provider.dart';

class UserHelper extends FirestoreHelper {
  Future createUser(UserProfile user, String uid) async {
    await db
        .collection('users')
        .doc(uid)
        .set(user.toMap())
        .onError((error, stackTrace) => throw '$error');
  }

  Future<Map<String, dynamic>> getUser(String uid) async {
    Map<String, dynamic> data = {};
    await db.collection('users').doc(uid).get().then((value) {
      data = value.data()!;
    });
    return data;
  }

  Future<String> updateUser(
      String uid, Map<String, dynamic> data, BuildContext context) async {
    String returnData = '';
    var userRef = db.collection('users').doc(uid);
    await userRef.update(data).then((value) async {
      var profile = await getUser(uid);

      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false).saveUser(
          UserProfile.fromMap(profile),
        );
      }
      returnData = "Data successfully updated!";
    }, onError: (e) {
      throw "Error updating document $e";
    });
    return returnData;
  }
}
