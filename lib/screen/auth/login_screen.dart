import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/helper/user_helper.dart';
import 'package:satria_optik/model/user.dart';
import 'package:satria_optik/provider/user_provider.dart';

import '../home/home_navigation_controller.dart';
import 'firebase_auth_logic.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  static const routeName = '/login';

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView(
              children: [
                const Text(
                  'Welcome Back!!',
                  style: TextStyle(fontSize: 40),
                ),
                Image.asset('assets/icons/sign-in.png'),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: passController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _navigateToForgotPassword(context);
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _login(context);
                        },
                        child: const Text('LOGIN'),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          _signWithGoogle(context);
                        },
                        icon: const Icon(Icons.g_mobiledata_rounded),
                        label: const Text('Login Using Google'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.apple),
                        label: const Text('Login Using Apple'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          _navigateToRegister(context);
                        },
                        child: const Text('Don\'t have an account? Register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password'),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        var uid = FirebaseAuth.instance.currentUser!.uid;

        var user = await UserHelper().getUser(uid);
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .saveUser(UserProfile.fromMap(user));
          Navigator.of(context).pushReplacementNamed(HomeNavigation.routeName);
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log in: $error'),
        ),
      );
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, ForgotPasswordPage.routeName);
  }

  void _signWithGoogle(BuildContext context) async {
    // var dataSignIn = await signInWithGoogle();
    await signInWithGoogle().then((value) async {
      var uid = value.user!.uid;
      var user = await UserHelper().getUser(uid);
      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .saveUser(UserProfile.fromMap(user));
        Navigator.of(context).pushReplacementNamed(HomeNavigation.routeName);
      }
    }).catchError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
        ),
      );
    });
  }
}
