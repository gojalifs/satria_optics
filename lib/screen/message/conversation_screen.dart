import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/model/chat.dart';
import 'package:satria_optik/provider/chat_provider.dart';
import 'package:satria_optik/utils/custom_function.dart';

class ConversationPage extends StatefulWidget {
  static String routeName = '/conversation';
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final controller = TextEditingController();
  var stream = FirebaseFirestore.instance
      .collection('users')
      .doc('4120VSJKzENrB9wNJ6CG1lTyao33')
      .collection('chats')
      .orderBy('timestamp')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat With Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      onTapOutside: (event) {
                        primaryFocus?.unfocus();
                      },
                      decoration: const InputDecoration(
                        hintText: 'type message here...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.text.isEmpty
                        ? null
                        : () {
                            print('object');
                            Provider.of<ChatProvider>(context, listen: false)
                                .addNewChat(
                              Chat(message: controller.text, sender: 'user'),
                            );
                            controller.clear();
                          },
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                List<Chat> chatList = [];
                snapshot.data!.docs.map((e) {
                  var chat = Chat.fromMap(e.data());
                  chatList.add(chat);
                });
                chatList.sort(
                  (a, b) => a.timestamp!.compareTo(b.timestamp!),
                );

                return ListView(
                  // shrinkWrap: true,
                  children: snapshot.data!.docs.map((e) {
                    var chat = Chat.fromMap(e.data());

                    return ChatBubble(
                      chat: chat,
                      isSender: chat.sender == 'user',
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Chat? chat;
  final bool isSender;

  const ChatBubble({
    Key? key,
    this.chat,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.tertiary;

    var bubbleRadius = 15.0;
    var textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 18,
    );

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(isSender ? bubbleRadius : 0),
                  bottomRight: Radius.circular(isSender ? 0 : bubbleRadius),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 28, 6),
                    child: Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat?.message ?? '',
                          style: textStyle,
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Format.hourFormat(chat?.timestamp),
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 20),
                            isSender
                                ? const SizedBox()
                                : Text(
                                    '${chat?.sender}',
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 16,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    bottom: 4,
                    right: 6,
                    child: Icon(
                      Icons.done,
                      size: 18,
                      color: Color(0xFF97AD8E),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );

    // return Container(
    //   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    //   padding: const EdgeInsets.all(12.0),
    //   decoration: BoxDecoration(
    //     color: bgColor,
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(isSender ? 16.0 : 0),
    //       topRight: Radius.circular(isSender ? 0 : 16.0),
    //       bottomLeft: const Radius.circular(16.0),
    //       bottomRight: const Radius.circular(16.0),
    //     ),
    //   ),
    //   child: Column(
    //     crossAxisAlignment:
    //         isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         message ?? '',
    //         style: const TextStyle(
    //           color: Colors.black,
    //           fontSize: 16.0,
    //         ),
    //       ),
    //       const SizedBox(height: 4.0),
    //       Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text(
    //             Format.timeFormat(timestamp),
    //             style: const TextStyle(
    //               color: Colors.black54,
    //               fontSize: 12.0,
    //             ),
    //           ),
    //           if (isSender)
    //             const Icon(Icons.check, color: Colors.white, size: 16.0),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
