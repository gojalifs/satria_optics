import 'package:flutter/material.dart';
import 'package:satria_optik/screen/message/conversation_screen.dart';

class NotificationPage extends StatelessWidget {
  static String routeName = '/messenger';
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: ListView(
        children: [
          const Text(
            'Message from Optik Satria Jaya Admin',
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(ConversationPage.routeName);
            },
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Let we check it',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          const Text('Promotion Just for You'),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(ConversationPage.routeName);
            },
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Sunglassses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'With this new sun glasses, you would not to worry about the sun.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
