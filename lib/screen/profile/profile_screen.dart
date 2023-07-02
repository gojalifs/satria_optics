import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/user_provider.dart';
import 'package:satria_optik/screen/auth/login_screen.dart';
import 'package:satria_optik/screen/profile/address/address_screen.dart';

import '../../helper/user_helper.dart';
import 'change_profile_detail.dart';

class ProfilePage extends StatelessWidget {
  static String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        Card(
          child: Row(
            children: [
              Consumer<UserProvider>(
                builder: (context, value, child) => SizedBox(
                  height: 100,
                  child: value.userProfile?.avatarPath != null &&
                          value.userProfile!.avatarPath!.isNotEmpty
                      ? Image.network(
                          value.userProfile!.avatarPath!,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person_rounded,
                              size: 100,
                            );
                          },
                        )
                      : const Icon(
                          Icons.person_rounded,
                          size: 100,
                        ),
                ),
              ),
              const SizedBox(width: 20),
              Consumer<UserProvider>(
                builder: (context, user, child) {
                  var profile = user.userProfile!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        profile.email!,
                        style: const TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
        const Text('Change Your Information Here'),
        const SizedBox(height: 10),
        Card(
          child: Consumer<UserProvider>(
            builder: (context, value, child) {
              var user = value.userProfile!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInformationWidgetTile(
                    title: 'Name',
                    detail: user.name ?? '',
                  ),
                  UserInformationWidgetTile(
                    title: 'Username',
                    detail: user.username ?? '',
                  ),
                  UserInformationWidgetTile(
                    title: 'Email',
                    detail: user.email ?? '',
                  ),
                  UserInformationWidgetTile(
                    title: 'Phone',
                    detail: user.phone ?? '',
                  ),
                  UserInformationWidgetTile(
                    title: 'Gender',
                    detail: user.gender ?? '',
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AddressPage.routeName);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.map_rounded),
                      title: Text('Address'),
                      trailing: Icon(Icons.navigate_next_rounded),
                    ),
                  ),
                  const Divider(),
                  const Text('Connect Account With'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.g_mobiledata_rounded,
                          size: 50,
                        ),
                        onPressed: () async {
                          await UserHelper()
                              .connectWithGoogle()
                              .catchError((error, stackTrace) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(error)));
                          });
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text('Need Help? Contact Us'),
        const SizedBox(height: 10),
        const Card(
          child: Column(
            children: [
              ListTile(
                title: Text('Customer Service'),
                leading: Icon(Icons.headset_mic_rounded),
              ),
              Divider(),
              ListTile(
                title: Text('Send Email'),
                leading: Icon(Icons.mail_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Follow Us'),
        const SizedBox(height: 10),
        const Card(
          child: Column(
            children: [
              ListTile(
                title: Text('Instagram'),
                leading: ImageIcon(AssetImage('assets/icons/instagram.png')),
              ),
              Divider(),
              ListTile(
                title: Text('Twitter'),
                leading: ImageIcon(AssetImage('assets/icons/twitter.png')),
              ),
              Divider(),
              ListTile(
                title: Text('Facebook'),
                leading: ImageIcon(AssetImage('assets/icons/facebook.png')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await GoogleSignIn().signOut();
            if (context.mounted) {
              Provider.of<UserProvider>(context, listen: false).removeUser();
            }

            await FirebaseAuth.instance.signOut().then((value) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              ), (route) => false);
            });
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

class UserInformationWidgetTile extends StatelessWidget {
  final String title;
  final String detail;

  const UserInformationWidgetTile({
    Key? key,
    required this.title,
    required this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ChangeProfileDetailPage.routeName,
          arguments: [title, detail],
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              children: [
                Text(
                  detail,
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
                title == 'Email'
                    ? const SizedBox()
                    : const Icon(Icons.navigate_next_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
