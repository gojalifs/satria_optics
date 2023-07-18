import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<Map<String, dynamic>> getUser(String uid) async {
    Map<String, dynamic> data = {};
    await db.collection('users').doc(uid).get().then((value) {
      data = value.data()!;
    });
    return data;
  }

  Future<UserProfile> updateUser(Map<String, dynamic> data) async {
    try {
      var userRef = db.collection('users').doc(userID);
      await userRef.update(data);
      var profile = await getUser(userID!);

      return UserProfile.fromMap(profile);
    } catch (e) {
      throw "Error updating document, $e";
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
