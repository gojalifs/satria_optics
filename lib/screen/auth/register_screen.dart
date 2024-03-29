import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';
import '../../utils/common_widget.dart';

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
                      Consumer2<AuthProvider, UserProvider>(
                        builder: (context, auth, user, child) => ElevatedButton(
                          onPressed: () async {
                            await auth.registerWithEmail(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              phoneController.text.trim(),
                              passController.text.trim(),
                              birthController.text.trim(),
                              genderController.text.trim(),
                            );
                            if (context.mounted) {
                              user.getUser();
                            }
                          },
                          child: const Text('REGISTER'),
                        ),
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
}
