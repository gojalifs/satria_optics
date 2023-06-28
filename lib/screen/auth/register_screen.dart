import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/helper/user_helper.dart';
import 'package:satria_optik/model/user.dart';
import 'package:satria_optik/provider/user_provider.dart';
import 'package:satria_optik/screen/home/home_navigation_controller.dart';
import 'package:satria_optik/utils/common_widget.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  static const routeName = '/register';

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView(
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 20),
                Form(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: nameController,
                        label: 'Name',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: emailController,
                        label: 'Email',
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: phoneController,
                        label: 'Phone',
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: passController,
                        label: 'Password',
                        inputType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: birthController,
                        label: 'Birth',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: genderController,
                        label: 'Gender',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _register(
                            context,
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            passController.text,
                            birthController.text,
                            genderController.text,
                          );
                        },
                        child: const Text('REGISTER'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to the login page
                        },
                        child: const Text('Already have an account? Login'),
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

  Future<void> _register(BuildContext context, String name, String email,
      String phone, String password, String birth, String gender) async {
    UserProfile user = UserProfile(
      id: null,
      name: name,
      email: email,
      phone: phone,
      birth: birth,
      gender: gender,
      avatarPath: null,
    );

    var uid = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passController.text,
    )
        .catchError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    });

    await UserHelper().createUser(user, uid.user!.uid).then((value) {
      Provider.of<UserProvider>(context, listen: false).saveUser(user);
      return Navigator.of(context)
          .pushReplacementNamed(HomeNavigation.routeName);
    }).catchError(
      (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      },
    );
  }
}
