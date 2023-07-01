import 'dart:convert';

import 'package:flutter/foundation.dart';

class GlassFrame {
  final String? id;
  bool? favoritedBy;
  final List<String>? imageUrl;
  final String? name;
  final int? price;
  final String? rating;
  final String? description;
  final String? type;
  final String? shape;
  final String? gender;
  final String? material;
  final Map<String, dynamic>? colors;

  GlassFrame({
    this.id,
    this.favoritedBy,
    this.imageUrl,
    this.name,
    this.price,
    this.rating,
    this.description,
    this.type,
    this.shape,
    this.gender,
    this.material,
    this.colors,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'favoritedBy': favoritedBy,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'rating': rating,
      'description': description,
      'type': type,
      'shape': shape,
      'gender': gender,
      'material': material,
      'colors': colors,
    };
  }

  factory GlassFrame.fromMap(Map<String, dynamic> map) {
    return GlassFrame(
      id: map['id'],
      favoritedBy: map['favoritedBy'],
      imageUrl: List<String>.from(map['imageUrl']),
      name: map['name'],
      price: map['price']?.toInt(),
      rating: map['rating'].toString(),
      description: map['description'],
      type: map['type'],
      shape: map['shape'],
      gender: map['gender'],
      material: map['material'],
      colors: Map<String, dynamic>.from(map['colors']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GlassFrame.fromJson(String source) =>
      GlassFrame.fromMap(json.decode(source));

  GlassFrame copyWith({
    String? id,
    List<String>? imageUrl,
    String? name,
    int? price,
    String? rating,
    String? description,
    String? type,
    String? shape,
    String? gender,
    String? material,
    Map<String, dynamic>? colors,
  }) {
    return GlassFrame(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      type: type ?? this.type,
      shape: shape ?? this.shape,
      gender: gender ?? this.gender,
      material: material ?? this.material,
      colors: colors ?? this.colors,
    );
  }

  @override
  String toString() {
    return 'GlassFrame(id: $id, imageUrl: $imageUrl, name: $name, price: $price, rating: $rating, description: $description, type: $type, shape: $shape, gender: $gender, material: $material, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GlassFrame &&
        other.id == id &&
        other.favoritedBy == favoritedBy &&
        listEquals(other.imageUrl, imageUrl) &&
        other.name == name &&
        other.price == price &&
        other.rating == rating &&
        other.description == description &&
        other.type == type &&
        other.shape == shape &&
        other.gender == gender &&
        other.material == material &&
        mapEquals(other.colors, colors);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        favoritedBy.hashCode ^
        imageUrl.hashCode ^
        name.hashCode ^
        price.hashCode ^
        rating.hashCode ^
        description.hashCode ^
        type.hashCode ^
        shape.hashCode ^
        gender.hashCode ^
        material.hashCode ^
        colors.hashCode;
  }
}
