import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/user_provider.dart';
import 'package:satria_optik/screen/auth/login_screen.dart';
import 'package:satria_optik/screen/profile/address/address_screen.dart';
import 'package:satria_optik/screen/profile/avatar_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/user_helper.dart';
import 'change_profile_detail.dart';

class ProfilePage extends StatelessWidget {
  static String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String heroTag = 'user';
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        Card(
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AvatarPage.routeName,
                    arguments: heroTag,
                  );
                },
                child: Consumer<UserProvider>(
                  builder: (context, value, child) => Hero(
                    tag: heroTag,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: value.userProfile?.avatarPath != null &&
                              value.userProfile!.avatarPath!.isNotEmpty
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              onBackgroundImageError:
                                  (exception, stackTrace) {},
                              backgroundImage: MemoryImage(
                                File(value.userProfile!.image!.path)
                                    .readAsBytesSync(),
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              size: 100,
                            ),
                    ),
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
        const SizedBox(height: 10),
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
                    title: 'Phone',
                    detail: user.phone ?? '',
                  ),
                  UserInformationWidgetTile(
                    title: 'Gender',
                    detail: user.gender ?? '',
                  ),
                  UserInformationWidgetTile(
                    title: 'Email',
                    detail: user.email ?? '',
                  ),
                  const UserInformationWidgetTile(
                    title: 'Password',
                    detail: 'change password here',
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
                        icon: const ImageIcon(
                          AssetImage('assets/icons/google.png'),
                          size: 50,
                        ),
                        onPressed: () async {
                          await UserHelper()
                              .connectWithGoogle()
                              .catchError((error, _) {
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
        Card(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '081318591184',
                  );
                  await launchUrl(launchUri);
                },
                child: const ListTile(
                  title: Text('Customer Service'),
                  leading: Icon(Icons.headset_mic_rounded),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () async {
                  final Uri launchUri = Uri(
                    scheme: 'mailto',
                    path: 'satriaoptik@gmail.com',
                  );
                  await launchUrl(launchUri);
                },
                child: const ListTile(
                  title: Text('Send Email'),
                  leading: Icon(Icons.mail_rounded),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Follow Us'),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              InkWell(
                /// TODO chane the url
                onTap: () async {
                  await openLink('https://www.instagram.com/cikarangdaily/');
                },
                child: const ListTile(
                  title: Text('Instagram'),
                  leading: ImageIcon(AssetImage('assets/icons/instagram.png')),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () async {
                  await openLink('https://twitter.com/fajallll');
                },
                child: const ListTile(
                  title: Text('Twitter'),
                  leading: ImageIcon(AssetImage('assets/icons/twitter.png')),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () async {
                  await openLink('https://www.tiktok.com/@theprediction_');
                },
                child: const ListTile(
                  title: Text('Tik Tok'),
                  leading: ImageIcon(AssetImage('assets/icons/tik-tok.png')),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () async {
                  await openLink('https://facebook.com/fajar.zydyx');
                },
                child: const ListTile(
                  title: Text('Facebook'),
                  leading: ImageIcon(AssetImage('assets/icons/facebook.png')),
                ),
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
                  return const LoginPage();
                },
              ), (route) => false);
            });
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }

  Future<void> callTo(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future openLink(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $uri');
    }
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
                const Icon(Icons.navigate_next_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
