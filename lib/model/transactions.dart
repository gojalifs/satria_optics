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

  Transactions({
    this.id,
    this.cartProduct,
    this.address,
    this.shipper,
    this.subTotal,
    this.shippingFee,
    this.discount,
    this.total,
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
      'total': total,
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
    };
  }

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
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transactions(id: $id, cartProduct: $cartProduct, address: $address, shipper: $shipper, subTotal: $subTotal, shippingFee: $shippingFee, discount: $discount, total: $total)';
  }

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
        other.total == total;
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
        total.hashCode;
  }
}
