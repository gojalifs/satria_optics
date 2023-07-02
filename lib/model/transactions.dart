import 'dart:convert';

import 'address.dart';
import 'cart.dart';

class Transactions {
  final String? id;
  final Cart? cartProduct;
  final Address? address;
  final String? shipper;
  final double? subTotal;
  final double? shippingFee;
  final double? discount;
  final double? total;

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
    Cart? cartProduct,
    Address? address,
    String? shipper,
    double? subTotal,
    double? shippingFee,
    double? discount,
    double? total,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cartProduct': cartProduct?.toMap(),
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
      cartProduct:
          map['cartProduct'] != null ? Cart.fromMap(map['cartProduct']) : null,
      address: map['address'] != null ? Address.fromMap(map['address']) : null,
      shipper: map['shipper'],
      subTotal: map['subTotal']?.toDouble(),
      shippingFee: map['shippingFee']?.toDouble(),
      discount: map['discount']?.toDouble(),
      total: map['total']?.toDouble(),
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
        other.cartProduct == cartProduct &&
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
