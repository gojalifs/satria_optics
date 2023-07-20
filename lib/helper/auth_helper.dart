import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:satria_optik/helper/firestore_helper.dart';

import '../model/user.dart';
import 'user_helper.dart';

class AuthHelper extends FirestoreHelper {
  Future<bool> getLoginStatus() async {
    try {
      final user = await FirebaseAuth.instance.authStateChanges().first;

      if (user != null) {
        return true;
      } else {
        throw 'logged out';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInwithPass(String email, String pass) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
  }

  Future signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      var emails = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(googleUser!.email);
      // Obtain the auth details from the request
      if (emails.isNotEmpty && emails.first == 'password') {
        throw '''You must login using password and then connect to google '''
            '''in your profile''';
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential

      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String uid = userCredential.user?.uid ?? 'nuull';

      if (emails.isEmpty) {
        UserHelper helper = UserHelper();
        helper.createUser(
            UserProfile(
                name: googleUser.displayName!,
                email: googleUser.email,
                phone: '',
                birth: '',
                gender: '',
                avatarPath: googleUser.photoUrl),
            uid);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> registerEmail(String name, String email, String phone,
      String password, String birth, String gender) async {
    UserProfile user = UserProfile(
      id: null,
      name: name,
      email: email,
      phone: phone,
      birth: birth,
      gender: gender,
      avatarPath: null,
    );

    try {
      var uid = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await UserHelper().createUser(user, uid.user!.uid);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
