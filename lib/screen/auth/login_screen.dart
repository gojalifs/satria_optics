import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/provider/auth_provider.dart';
import 'package:satria_optik/screen/auth/tos_screen.dart';

import '../../provider/user_provider.dart';
import '../home/home_navigation_controller.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            primaryFocus?.unfocus();
            ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
          },
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
                  key: formKey,
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
                            Navigator.pushNamed(
                                context, ForgotPasswordPage.routeName);
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      Row(
                        children: [
                          Consumer<AuthProvider>(
                            builder: (context, authProv, child) {
                              return Checkbox.adaptive(
                                value: authProv.isTosApproved,
                                onChanged: (value) {
                                  authProv.tosValue = !authProv.isTosApproved;
                                  print(authProv.isTosApproved);
                                },
                              );
                            },
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'By logging in, you accept our ',
                                ),
                                TextSpan(
                                  text: 'Term And Privacy Policy',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  // Add an onTap function to handle the button tap
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .pushNamed(TOSPage.routeName);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LoginWithPassword(
                        emailController: emailController,
                        passController: passController,
                        formKey: formKey,
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('or'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Consumer2<AuthProvider, UserProvider>(
                        builder: (context, auth, user, child) =>
                            ElevatedButton.icon(
                          onPressed: auth.isTosApproved
                              ? () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LoadingAnimationWidget
                                          .threeArchedCircle(
                                              color: Colors.white, size: 25);
                                    },
                                  );
                                  try {
                                    await auth.signWithGoogle().then(
                                      (value) async {
                                        await user.getUser().then((value) {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  HomeNavigation.routeName);
                                        });
                                      },
                                    );
                                  } catch (e) {
                                    Navigator.of(context).pop();
                                    if (e.toString().contains('null')) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$e'),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.g_mobiledata_rounded),
                          label: const Text('Login Using Google'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
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
}

class LoginWithPassword extends StatelessWidget {
  const LoginWithPassword({
    Key? key,
    required this.emailController,
    required this.passController,
    required this.formKey,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProv, child) => ElevatedButton(
        onPressed: authProv.isTosApproved
            ? () async {
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()) {
                  try {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return LoadingAnimationWidget.threeArchedCircle(
                            color: Colors.white, size: 25);
                      },
                    );
                    await authProv
                        .signWithPassword(emailController.text.trim(),
                            passController.text.trim())
                        .then(
                      (value) {
                        if (context.mounted) {
                          Provider.of<UserProvider>(context, listen: false)
                              .getUser();
                          Navigator.of(context)
                              .pushReplacementNamed(HomeNavigation.routeName);
                        }
                      },
                    );
                  } on FirebaseAuthException {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid Credentials'),
                      ),
                    );
                  } catch (e) {
                    debugPrint('$e');
                  }
                }
              }
            : null,
        child: const Text('LOGIN'),
      ),
    );
  }
}
