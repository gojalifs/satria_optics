import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:satria_optik/helper/user_helper.dart';
import 'package:satria_optik/model/user.dart';

Future<UserCredential> signInWithGoogle() async {
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

    return userCredential;
  } catch (e) {
    rethrow;
  }
}
