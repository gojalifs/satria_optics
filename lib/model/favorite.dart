import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:satria_optik/model/glass_frame.dart';

class Favorite {
  final String? id;
  final GlassFrame? frame;

  Favorite({
    this.id,
    this.frame,
  });

  factory Favorite.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    GlassFrame frame,
  ) {
    return Favorite(
      id: snapshot.id,
      frame: frame,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'frame': frame?.toMap(),
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      frame: map['frame'] != null ? GlassFrame.fromMap(map['frame']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(String source) =>
      Favorite.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Favorite && other.id == id && other.frame == frame;
  }

  @override
  int get hashCode => id.hashCode ^ frame.hashCode;
}
