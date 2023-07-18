import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class AvatarPage extends StatelessWidget {
  static String routeName = '/avatarPage';
  final String heroTag;
  const AvatarPage({
    Key? key,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Your Avatar'),
      ),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, userProv, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    userProv.userProfile!.avatarPath!,
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person_rounded,
                      size: 200,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Tap Me To Change Your Photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
