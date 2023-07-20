import 'dart:io';

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
    return WillPopScope(
      onWillPop: () {
        Provider.of<UserProvider>(context, listen: false).removeImage();
        return Future.value(true);
      },
      child: Scaffold(
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
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 2),
                    borderRadius: BorderRadius.circular(360),
                  ),
                  child: Hero(
                    tag: heroTag,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      onBackgroundImageError: (exception, stackTrace) {},
                      backgroundImage: userProv.image != null
                          ? MemoryImage(
                              File(userProv.image!.path).readAsBytesSync(),
                            )
                          : MemoryImage(
                              File(userProv.userProfile!.image!.path)
                                  .readAsBytesSync(),
                            ),
                    ),
                  ),
                ),
                if (userProv.image == null)
                  ElevatedButton(
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => BottomSheet(
                          onClosing: () {},
                          builder: (context) => Container(
                            height: 90,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    await userProv.getPictGallery();
                                  },
                                  child: const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.photo_rounded),
                                      Text('Gallery'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    await userProv.getPictCamera();
                                  },
                                  child: const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.photo_camera_rounded),
                                      Text('Camera'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Tap Me To Change Your Photo'),
                  )
                else
                  ElevatedButton(
                    onPressed: () async {
                      await userProv.updateAvatar().then((value) {
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text('Save My Avatar'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
