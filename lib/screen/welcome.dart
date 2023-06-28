import 'package:flutter/material.dart';
import 'package:satria_optik/screen/auth/login_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 20,
            right: 10,
            left: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Satria Optik',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Find The Perfect Eyewear For You.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Image.asset('assets/images/onboard.png'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text(
                  'Start Shopping Now',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
