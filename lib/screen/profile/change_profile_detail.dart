import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/user_provider.dart';

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
  UserHelper userHelper = UserHelper();

  final formKey = GlobalKey<FormState>();

  String? genderValue;

  @override
  void initState() {
    controller = TextEditingController(text: widget.data);
    genderValue = widget.data;

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
              Text('Change your ${widget.beChanged}'),
              const SizedBox(height: 20),
              if (widget.beChanged != 'Gender')
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
              const SizedBox(height: 20),
              Consumer<UserProvider>(
                builder: (context, value, child) => ElevatedButton(
                  onPressed: () async {
                    // validate data
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();

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
                        return;
                      }

                      try {
                        Map<String, dynamic> changedData = {
                          widget.beChanged.toLowerCase(): controller.text.trim()
                        };
                        if (widget.beChanged == 'Gender') {
                          changedData = {
                            widget.beChanged.toLowerCase(): genderValue
                          };
                        }
                        await value.updateUser(changedData);

                        if (mounted) {
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
            ],
          ),
        ),
      ),
    );
  }
}
