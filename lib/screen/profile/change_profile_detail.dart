import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/auth_provider.dart';
import 'package:satria_optik/provider/user_provider.dart';
import 'package:satria_optik/utils/custom_loading.dart';

import '../../helper/user_helper.dart';
import '../../utils/common_widget.dart';

class ChangeProfileDetailPage extends StatefulWidget {
  static String routeName = '/changeprofiledetail';
  final String beChanged;
  final String data;

  const ChangeProfileDetailPage({
    Key? key,
    required this.beChanged,
    required this.data,
  }) : super(key: key);

  @override
  State<ChangeProfileDetailPage> createState() =>
      _ChangeProfileDetailPageState();
}

class _ChangeProfileDetailPageState extends State<ChangeProfileDetailPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController passController = TextEditingController();
  var newPassController = TextEditingController();
  UserHelper userHelper = UserHelper();

  final formKey = GlobalKey<FormState>();

  String? genderValue;
  String oldEmail = '';
  bool isLinkedToGoogle = false;
  bool isVisible = false;
  bool isObscure = true;

  @override
  void initState() {
    if (widget.beChanged == 'Password') {
      controller = TextEditingController(text: '');
    } else {
      controller = TextEditingController(text: widget.data);
    }
    genderValue = widget.data;
    oldEmail = widget.data;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change ${widget.beChanged}'),
      ),
      body: GestureDetector(
        onTap: () {
          ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              if (widget.beChanged.toLowerCase() == 'email')
                const Text(
                  '''If you change your email, you must using email and'''
                  ''' password on your next login, or you must connect again to google''',
                  style: TextStyle(color: Colors.grey),
                ),
              if (widget.beChanged.toLowerCase() == 'password')
                const Text(
                  "You can't change your password if you register using google",
                  style: TextStyle(color: Colors.grey),
                ),
              if (widget.beChanged != 'Gender' &&
                  widget.beChanged != 'Password')
                const SizedBox(height: 20),
              if (widget.beChanged != 'Gender' &&
                  widget.beChanged != 'Password')
                CustomTextFormField(
                  controller: controller,
                  label: widget.beChanged,
                  inputType: TextInputType.phone,
                  inputFormatters: widget.beChanged == 'Phone'
                      ? [FilteringTextInputFormatter.allow(RegExp(r'^\+?\d*'))]
                      : null,
                  maxLength: widget.beChanged == 'Phone' ? 24 : null,
                  validator: widget.beChanged == 'Email'
                      ? (p0) {
                          if (!p0!.contains('@')) {
                            return 'Email must contains @';
                          }
                          return null;
                        }
                      : null,
                ),
              if (widget.beChanged == 'Email' || widget.beChanged == 'Password')
                const SizedBox(height: 20),
              if (widget.beChanged == 'Email' || widget.beChanged == 'Password')
                TextFormField(
                  controller: passController,
                  autofillHints: const [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    labelStyle: Theme.of(context).textTheme.labelLarge,
                    suffix: IconButton(
                      onPressed: () {
                        isVisible = !isVisible;
                        isObscure = !isObscure;
                        setState(() {});
                      },
                      icon: Icon(
                        isVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ),
                  ),
                  obscureText: isObscure,
                ),
              if (widget.beChanged == 'Email' || widget.beChanged == 'Password')
                const SizedBox(height: 20),
              if (widget.beChanged == 'Password')
                TextFormField(
                  controller: newPassController,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill new password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: Theme.of(context).textTheme.labelLarge,
                    suffix: IconButton(
                      onPressed: () {
                        isVisible = !isVisible;
                        isObscure = !isObscure;
                        setState(() {});
                      },
                      icon: Icon(
                        isVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ),
                  ),
                  obscureText: isObscure,
                ),
              if (widget.beChanged == 'Gender')
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      value: 'Male',
                      groupValue: genderValue,
                      onChanged: (value) {
                        genderValue = value;
                        setState(() {});
                      },
                      title: const Text('Male'),
                    ),
                    RadioListTile(
                      value: 'Female',
                      groupValue: genderValue,
                      onChanged: (value) {
                        genderValue = value;
                        setState(() {});
                      },
                      title: const Text('Female'),
                    ),
                  ],
                ),
              if (widget.beChanged != 'Email')
                const SizedBox(height: 20),
              Consumer2<UserProvider, AuthProvider>(
                builder: (context, userProv, authProv, child) => ElevatedButton(
                  onPressed: () async {
                    // validate data
                    if (formKey.currentState!.validate()) {
                      try {
                        ScaffoldMessenger.maybeOf(context)
                            ?.hideCurrentSnackBar();

                        // if no data changed
                        if (controller.text == widget.data &&
                            widget.beChanged != "Gender") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data Not Changed'),
                            ),
                          );

                          return;
                        }

                        CustomLoadingAnimation.show(context);

                        // check for duplicate data
                        bool isPhoneUsed = await userHelper.isPhoneUsernameUsed(
                            controller.text, widget.beChanged.toLowerCase());
                        if (!mounted) {
                          return;
                        }
                        if (isPhoneUsed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data Already Used'),
                            ),
                          );
                          CustomLoadingAnimation.hide(context);

                          return;
                        }

                        Map<String, dynamic> changedData = {
                          widget.beChanged.toLowerCase(): controller.text.trim()
                        };
                        if (widget.beChanged == 'Gender') {
                          changedData = {
                            widget.beChanged.toLowerCase(): genderValue
                          };
                        }

                        if (widget.beChanged == 'Email') {
                          var loginMethod =
                              await authProv.checkLoginMethod(oldEmail);
                          if (loginMethod.contains('google.com') && mounted) {
                            isLinkedToGoogle = true;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Email is connected to google, please disconnect first",
                                ),
                              ),
                            );
                            CustomLoadingAnimation.hide(context);

                            return;
                          }
                        }

                        if (widget.beChanged == 'Email') {
                          await authProv.signWithPassword(
                              oldEmail, passController.text);
                        }
                        if (widget.beChanged == 'Password') {
                          await authProv.updatePassword(
                            userProv.userProfile?.email,
                            passController.text,
                            newPassController.text,
                          );
                        } else {
                          await userProv.updateUser(changedData);
                        }

                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Data successfully updated!")),
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$e')),
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
              if (isLinkedToGoogle)
                Consumer<AuthProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: () async {
                      try {
                        if (value.state == ConnectionState.active) {
                          CustomLoadingAnimation.show(context);
                        }
                        await value.unlinkGoogle();
                        isLinkedToGoogle = false;
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: const Text('Disconnect From Google'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
