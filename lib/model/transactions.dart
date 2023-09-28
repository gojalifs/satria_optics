import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'address.dart';
import 'cart.dart';

class Transactions {
  final String? id;
  final List<Cart>? cartProduct;
  final Address? address;
  final String? shipper;
  final int? subTotal;
  final int? shippingFee;
  final int? discount;
  final int? total;
  final String? receiptNumber;
  final String? paymentStatus;
  final String? paymentId;
  final String? redirectUrl;
  final String? deliveryStatus;
  final Timestamp? orderMadeTime;
  final Timestamp? paymentMadeTime;
  final Timestamp? paymentExpiry;
  final Timestamp? receiptUpdateTime;
  final Timestamp? orderFinishTime;
  final String? orderStatus;

  Transactions({
    this.id,
    this.cartProduct,
    this.address,
    this.shipper,
    this.subTotal,
    this.shippingFee,
    this.discount,
    this.total,
    this.receiptNumber = 'Receipt Not Updated Yet',
    this.paymentStatus = 'Pending',
    this.paymentId,
    this.redirectUrl,
    this.deliveryStatus = 'Waiting For Payment',
    this.orderMadeTime,
    this.paymentMadeTime,
    this.paymentExpiry,
    this.receiptUpdateTime,
    this.orderFinishTime,
    this.orderStatus = 'waitingPayment',
  });

  Transactions copyWith({
    String? id,
    List<Cart>? cartProduct,
    Address? address,
    String? shipper,
    int? subTotal,
    int? shippingFee,
    int? discount,
    int? total,
    String? receiptNumber,
    String? paymentStatus,
    String? paymentId,
    String? redirectUrl,
    String? deliveryStatus,
    Timestamp? orderMadeTime,
    Timestamp? paymentMadeTime,
    Timestamp? paymentExpiry,
    Timestamp? receiptUpdateTime,
    Timestamp? orderFinishTime,
    String? orderStatus,
  }) {
    return Transactions(
      id: id ?? this.id,
      cartProduct: cartProduct ?? this.cartProduct,
      address: address ?? this.address,
      shipper: shipper ?? this.shipper,
      subTotal: subTotal ?? this.subTotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentId: paymentId ?? this.paymentId,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      orderMadeTime: orderMadeTime ?? this.orderMadeTime,
      paymentMadeTime: paymentMadeTime ?? this.paymentMadeTime,
      paymentExpiry: paymentExpiry ?? this.paymentExpiry,
      receiptUpdateTime: receiptUpdateTime ?? this.receiptUpdateTime,
      orderFinishTime: orderFinishTime ?? this.orderFinishTime,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }

  Map<String, dynamic> toFirfestore(List<String> cartId, String addressId) {
    return {
      'id': id,
      'cartProduct': cartId as List<DocumentReference>,
      'address': addressId as DocumentReference,
      'shipper': shipper,
      'subTotal': subTotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'receiptNumber': receiptNumber,
      'paymentStatus': paymentStatus,
      'deliveryStatus': deliveryStatus,
      'orderMadeTime': FieldValue.serverTimestamp(),
      'paymentMadeTime': paymentMadeTime,
      'receiptUpdateTime': receiptUpdateTime,
      'orderFinishTime': orderFinishTime
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cartProduct': cartProduct?.map((x) => x.toMap()).toList(),
      'address': address?.toMap(),
      'shipper': shipper,
      'subTotal': subTotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'receiptNumber': receiptNumber,
      'paymentStatus': paymentStatus,
      'paymentId': paymentId,
      'redirectUrl': redirectUrl,
      'deliveryStatus': deliveryStatus,
      'orderMadeTime': orderMadeTime,
      'paymentMadeTime': paymentMadeTime,
      'paymentExpiry': paymentExpiry,
      'receiptUpdateTime': receiptUpdateTime,
      'orderFinishTime': orderFinishTime,
      'orderStatus': orderStatus,
    };
  }

  /// TODO MAKE NEW MODEL
  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'],
      cartProduct: map['cartProduct'] != null
          ? List<Cart>.from(map['cartProduct']?.map((x) => Cart.fromMap(x)))
          : null,
      address: map['address'] != null ? Address.fromMap(map['address']) : null,
      shipper: map['shipper'],
      subTotal: map['subTotal']?.toInt(),
      shippingFee: map['shippingFee']?.toInt(),
      discount: map['discount']?.toInt(),
      total: map['total']?.toInt(),
      receiptNumber: map['receiptNumber'],
      paymentStatus: map['paymentStatus'],
      paymentId: map['paymentId'],
      redirectUrl: map['redirectUrl'],
      deliveryStatus: map['deliveryStatus'],
      orderMadeTime: map['orderMadeTime'],
      paymentMadeTime: map['paymentMadeTime'],
      paymentExpiry: map['paymentExpiry'],
      receiptUpdateTime: map['receiptUpdateTime'],
      orderFinishTime: map['orderFinishTime'],
      orderStatus: map['orderStatus'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transactions &&
        other.id == id &&
        listEquals(other.cartProduct, cartProduct) &&
        other.address == address &&
        other.shipper == shipper &&
        other.subTotal == subTotal &&
        other.shippingFee == shippingFee &&
        other.discount == discount &&
        other.total == total &&
        other.receiptNumber == receiptNumber &&
        other.paymentStatus == paymentStatus &&
        other.paymentId == paymentId &&
        other.redirectUrl == redirectUrl &&
        other.deliveryStatus == deliveryStatus &&
        other.orderMadeTime == orderMadeTime &&
        other.paymentMadeTime == paymentMadeTime &&
        other.paymentExpiry == paymentExpiry &&
        other.receiptUpdateTime == receiptUpdateTime &&
        other.orderFinishTime == orderFinishTime &&
        other.orderStatus == orderStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cartProduct.hashCode ^
        address.hashCode ^
        shipper.hashCode ^
        subTotal.hashCode ^
        shippingFee.hashCode ^
        discount.hashCode ^
        total.hashCode ^
        receiptNumber.hashCode ^
        paymentStatus.hashCode ^
        paymentId.hashCode ^
        redirectUrl.hashCode ^
        deliveryStatus.hashCode ^
        orderMadeTime.hashCode ^
        paymentMadeTime.hashCode ^
        paymentExpiry.hashCode ^
        receiptUpdateTime.hashCode ^
        orderFinishTime.hashCode ^
        orderStatus.hashCode;
  }

  @override
  String toString() {
    return 'Transactions(id: $id, cartProduct: $cartProduct, address: $address, shipper: $shipper, subTotal: $subTotal, shippingFee: $shippingFee, discount: $discount, total: $total, receiptNumber: $receiptNumber, paymentStatus: $paymentStatus, paymentId: $paymentId, redirectUrl: $redirectUrl, deliveryStatus: $deliveryStatus, orderMadeTime: $orderMadeTime, paymentMadeTime: $paymentMadeTime, paymentExpiry: $paymentExpiry, receiptUpdateTime: $receiptUpdateTime, orderFinishTime: $orderFinishTime), orderStatus: $orderStatus';
  }
}

class ProductOnCart {
  final String? imageVariant;
  final String? description;
  final bool? favoritedBy;
  final String? name;
  final int? price;
  final String? rating;
  final String? type;
  final String? shape;
  final String? gender;
  final String? material;

  ProductOnCart({
    this.imageVariant,
    this.description,
    this.favoritedBy,
    this.name,
    this.price,
    this.rating,
    this.type,
    this.shape,
    this.gender,
    this.material,
  });

  ProductOnCart copyWith({
    String? imageVariant,
    String? description,
    bool? favoritedBy,
    String? name,
    int? price,
    String? rating,
    String? type,
    String? shape,
    String? gender,
    String? material,
  }) {
    return ProductOnCart(
      imageVariant: imageVariant ?? this.imageVariant,
      description: description ?? this.description,
      favoritedBy: favoritedBy ?? this.favoritedBy,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      type: type ?? this.type,
      shape: shape ?? this.shape,
      gender: gender ?? this.gender,
      material: material ?? this.material,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageVariant': imageVariant,
      'description': description,
      'favoritedBy': favoritedBy,
      'name': name,
      'price': price,
      'rating': rating,
      'type': type,
      'shape': shape,
      'gender': gender,
      'material': material,
    };
  }

  factory ProductOnCart.fromMap(Map<String, dynamic> map) {
    return ProductOnCart(
      imageVariant: map['colors'],
      description: map['description'],
      favoritedBy: map['favoritedBy'],
      name: map['name'],
      price: map['price']?.toInt(),
      rating: map['rating'],
      type: map['type'],
      shape: map['shape'],
      gender: map['gender'],
      material: map['material'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOnCart.fromJson(String source) =>
      ProductOnCart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductOnCart(imageVariant: $imageVariant, description: $description, favoritedBy: $favoritedBy, name: $name, price: $price, rating: $rating, type: $type, shape: $shape, gender: $gender, material: $material)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductOnCart &&
        other.imageVariant == imageVariant &&
        other.description == description &&
        other.favoritedBy == favoritedBy &&
        other.name == name &&
        other.price == price &&
        other.rating == rating &&
        other.type == type &&
        other.shape == shape &&
        other.gender == gender &&
        other.material == material;
  }

  @override
  int get hashCode {
    return imageVariant.hashCode ^
        description.hashCode ^
        favoritedBy.hashCode ^
        name.hashCode ^
        price.hashCode ^
        rating.hashCode ^
        type.hashCode ^
        shape.hashCode ^
        gender.hashCode ^
        material.hashCode;
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
