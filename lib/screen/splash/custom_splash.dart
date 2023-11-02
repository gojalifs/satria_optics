import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/screen/auth/login_screen.dart';

import '../../model/user.dart';
import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';
import '../home/home_navigation_controller.dart';

class SplashPage extends StatefulWidget {
  static String routeName = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var user = UserProfile();
  late Brightness brightness;

  @override
  void initState() {
    brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    Provider.of<AuthProvider>(context, listen: false)
        .getLoginStatus()
        .then((uid) async {
      if (uid != null && uid.isNotEmpty) {
        await Provider.of<UserProvider>(context, listen: false).getUser();

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, HomeNavigation.routeName);
        }
      }
    }).onError((error, stackTrace) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      if (error != 'logged out') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something error, try to login again'),
          ),
        );
      }
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
            SizedBox(
              width: 100,
              height: 100,
              child: brightness == Brightness.dark
                  ? Image.asset("assets/launcher/launcher_icon-dark.png")
                  : Image.asset("assets/launcher/launcher_icon.png"),
            ),
            const SizedBox(height: 20),
            LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
