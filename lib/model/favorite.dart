import 'dart:convert';

import 'package:satria_optik/model/glass_frame.dart';

class Favorite {
  final String? id;
  final GlassFrame? frame;

  Favorite({
    this.id,
    this.frame,
  });

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

  factory Favorite.fromJson(String source) {
    return Favorite.fromMap(json.decode(source));
  }
}
