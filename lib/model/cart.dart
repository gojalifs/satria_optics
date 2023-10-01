import 'dart:convert';

import 'package:satria_optik/model/glass_frame.dart';
import 'package:satria_optik/model/lens.dart';

class Cart {
  String? id;
  GlassFrame product;
  Lens lens;
  String color;
  MinusData? minusData;

  double? totalPrice;

  Cart({
    this.id,
    required this.product,
    required this.lens,
    required this.color,
    this.minusData,
    this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'lens': lens.toMap(),
      'color': color,
      'minusData': minusData?.toMap(),
      'totalPrice': totalPrice,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'],
      product: GlassFrame.fromMap(map['product']),
      lens: Lens.fromMap(map['lens']),
      color: map['color'] ?? '',
      minusData:
          map['minusData'] != null ? MinusData.fromMap(map['minusData']) : null,
      totalPrice: map['totalPrice']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        other.id == id &&
        other.product == product &&
        other.lens == lens &&
        other.color == color &&
        other.minusData == minusData &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        product.hashCode ^
        lens.hashCode ^
        color.hashCode ^
        minusData.hashCode ^
        totalPrice.hashCode;
  }
}

class MinusData {
  String? leftEyeMinus;
  String? rightEyeMinus;
  String? leftEyePlus;
  String? rightEyePlus;
  String? recipePath;

  MinusData({
    this.leftEyeMinus,
    this.rightEyeMinus,
    this.leftEyePlus,
    this.rightEyePlus,
    this.recipePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'leftEyeMinus': leftEyeMinus,
      'rightEyeMinus': rightEyeMinus,
      'leftEyePlus': leftEyePlus,
      'rightEyePlus': rightEyePlus,
      'recipePath': recipePath,
    };
  }

  factory MinusData.fromMap(Map<String, dynamic> map) {
    return MinusData(
      leftEyeMinus: map['leftEyeMinus'],
      rightEyeMinus: map['rightEyeMinus'],
      leftEyePlus: map['leftEyePlus'],
      rightEyePlus: map['rightEyePlus'],
      recipePath: map['recipePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MinusData.fromJson(String source) =>
      MinusData.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MinusData &&
        other.leftEyeMinus == leftEyeMinus &&
        other.rightEyeMinus == rightEyeMinus &&
        other.leftEyePlus == leftEyePlus &&
        other.rightEyePlus == rightEyePlus &&
        other.recipePath == recipePath;
  }

  @override
  int get hashCode {
    return leftEyeMinus.hashCode ^
        rightEyeMinus.hashCode ^
        leftEyePlus.hashCode ^
        rightEyePlus.hashCode ^
        recipePath.hashCode;
  }
}
