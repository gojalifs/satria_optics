import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  static String routeName = '/conversation';
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Conversation Page')),
    );
  }
}
