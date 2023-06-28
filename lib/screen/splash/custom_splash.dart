import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/model/user.dart';
import 'package:satria_optik/provider/user_provider.dart';
import 'package:satria_optik/screen/auth/login_screen.dart';
import 'package:satria_optik/screen/home/home_navigation_controller.dart';

class SplashPage extends StatefulWidget {
  static String routeName = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var user = UserProfile();

  @override
  void initState() {
    getLoginStatus().then((value) async {
      if (value) {
        await getUser().then((value) {
          user = value;
        });
      }
      if (!mounted) {
        return;
      }
      Provider.of<UserProvider>(context, listen: false).saveUser(user);
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, HomeNavigation.routeName);
    }).onError((error, stackTrace) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

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

  Future<UserProfile> getUser() async {
    try {
      var userData = UserProfile();
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          userData = UserProfile.fromMap(data);
        },
        onError: (e) => throw "Error getting document: $e",
      );
      return userData;
    } catch (e) {
      throw 'errror $e';
    }
  }
}
