import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:satria_optik/model/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatStream = FirebaseFirestore.instance.collection('chats').snapshots();
  List<Chat> chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat With Admin'),
      ),
      body: StreamBuilder(
        stream: chatStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          var docs = snapshot.data?.docs;
          docs?.map((e) {
            Chat chat = Chat.fromMap(e.data());
            chat = chat.copyWith(id: e.id);
            chats.add(chat);
          });

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              return Card(
                child: Text('$index'),
              );
            },
          );
        },
      ),
    );
  }
}
