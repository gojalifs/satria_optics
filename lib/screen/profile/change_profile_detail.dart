import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:satria_optik/helper/user_helper.dart';

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
  @override
  void initState() {
    controller = TextEditingController(text: widget.data);
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text('Change your ${widget.beChanged}'),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: controller,
              label: widget.beChanged,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (controller.text == widget.data) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data Not Changed'),
                    ),
                  );
                  return;
                }
                var isPhoneUsed = await isPhoneNumberAlreadyUsed(
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
                UserHelper userHelper = UserHelper();
                var userID = FirebaseAuth.instance.currentUser!.uid;

                var result = await userHelper
                    .updateUser(
                  userID,
                  {widget.beChanged.toLowerCase(): controller.text.trim()},
                  context,
                )
                    .onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$error')),
                  );
                  debugPrint('$stackTrace');
                  return 'error';
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isPhoneNumberAlreadyUsed(String value, String key) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    if (key == 'phone') {
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: value)
          .get();
    } else if (key == 'username') {
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: value)
          .get();
    } else {
      return false;
    }

    return snapshot.docs.isNotEmpty;
  }
}
