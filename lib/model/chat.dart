import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String? id;
  final String? sender;
  final String? senderId;
  final String? message;
  final Timestamp? timestamp;

  Chat({
    this.id,
    this.sender,
    this.senderId,
    this.message,
    this.timestamp,
  });

  Chat copyWith({
    String? id,
    String? sender,
    String? senderId,
    String? message,
    Timestamp? timestamp,
  }) {
    return Chat(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'sender': sender,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      sender: map['sender'],
      senderId: map['senderId'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, sender: $sender, senderId: $senderId, message: $message, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.id == id &&
        other.sender == sender &&
        other.senderId == senderId &&
        other.message == message &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender.hashCode ^
        senderId.hashCode ^
        message.hashCode ^
        timestamp.hashCode;
  }
}
