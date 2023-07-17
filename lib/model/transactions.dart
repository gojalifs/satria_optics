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
        other.orderFinishTime == orderFinishTime;
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
        orderFinishTime.hashCode;
  }

  @override
  String toString() {
    return 'Transactions(id: $id, cartProduct: $cartProduct, address: $address, shipper: $shipper, subTotal: $subTotal, shippingFee: $shippingFee, discount: $discount, total: $total, receiptNumber: $receiptNumber, paymentStatus: $paymentStatus, paymentId: $paymentId, redirectUrl: $redirectUrl, deliveryStatus: $deliveryStatus, orderMadeTime: $orderMadeTime, paymentMadeTime: $paymentMadeTime, paymentExpiry: $paymentExpiry, receiptUpdateTime: $receiptUpdateTime, orderFinishTime: $orderFinishTime)';
  }
}
