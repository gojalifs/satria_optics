import 'package:flutter/material.dart';
import 'package:satria_optik/helper/chat_helper.dart';
import 'package:satria_optik/model/chat.dart';
import 'package:satria_optik/provider/base_provider.dart';

class ChatProvider extends BaseProvider {
  final _helper = ChatHelper();
  List<Chat> _chats = [];

  List<Chat> get chats => _chats;

  addNewChat(Chat chat) async {
    state = ConnectionState.active;
    try {
      _chats.add(chat);
      var id = await _helper.newMessage(chat);
      var i = _chats.indexOf(chat);
      _chats[i] = chat.copyWith(id: id);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }
}
