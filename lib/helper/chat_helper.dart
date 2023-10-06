import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:satria_optik/helper/firestore_helper.dart';
import 'package:satria_optik/model/chat.dart';

class ChatHelper extends FirestoreHelper {
  var uid = FirebaseAuth.instance.currentUser?.uid;
  listenChat() {
    final ref = db.collection('users').doc(uid).collection('chats');
    ref.snapshots().listen((event) {
      print(event.docs);
    });
  }

  Future<String> newMessage(Chat chat) async {
    try {
      print(uid);
      final ref = db.collection('users').doc(uid).collection('chats');
      chat = chat.copyWith(
        senderId: uid,
        timestamp: Timestamp.now(),
      );

      var doc = await ref.add(chat.toMap());
      print('success ${doc.id}');
      return doc.id;
    } on FirebaseException catch (e) {
      throw 'Error happened. code: $e';
    } catch (e, s) {
      print(s);
      throw 'Error happened.';
    }
  }
}
