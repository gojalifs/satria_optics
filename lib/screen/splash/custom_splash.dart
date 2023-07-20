import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';
import '../auth/login_screen.dart';
import '../home/home_navigation_controller.dart';

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
    Provider.of<AuthProvider>(context, listen: false)
        .getLoginStatus()
        .then((value) async {
      if (value) {
        await Provider.of<UserProvider>(context, listen: false).getUser();

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, HomeNavigation.routeName);
        }
      }
    }).onError((error, stackTrace) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.abc_rounded),
            LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  /// TODO pindahkan get user ini ke provider atau ke login, biar ga null saat relog
  /// mungkin bisa dibuatkan auth provider, biar login logout juga disitu
}
