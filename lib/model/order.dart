import 'dart:convert';

import 'package:satria_optik/model/glass_frame.dart';

class Order {
  final int id;
  final String number;
  final String address;
  final String time;
  final String status;
  final String? receiptNumber;
  final String paymentMethod;
  final int? deliveryFee;
  final int grandTotal;
  final OrderDetail orderDetail;

  Order({
    required this.id,
    required this.number,
    required this.address,
    required this.time,
    required this.status,
    this.receiptNumber,
    required this.paymentMethod,
    this.deliveryFee = 0,
    required this.grandTotal,
    required this.orderDetail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'address': address,
      'time': time,
      'status': status,
      'receiptNumber': receiptNumber,
      'paymentMethod': paymentMethod,
      'deliveryFee': deliveryFee,
      'grandTotal': grandTotal,
      'orderDetail': orderDetail.toMap(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toInt() ?? 0,
      number: map['number'] ?? '',
      address: map['address'] ?? '',
      time: map['time'] ?? '',
      status: map['status'] ?? '',
      receiptNumber: map['receiptNumber'],
      paymentMethod: map['paymentMethod'] ?? '',
      deliveryFee: map['deliveryFee']?.toInt(),
      grandTotal: map['grandTotal']?.toInt() ?? 0,
      orderDetail: OrderDetail.fromMap(map['orderDetail']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}

class OrderDetail {
  final GlassFrame product;
  final int qty;
  final int price;
  final int subTotal;

  OrderDetail({
    required this.product,
    required this.qty,
    required this.price,
    required this.subTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'qty': qty,
      'price': price,
      'subTotal': subTotal,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      product: GlassFrame.fromMap(map['product']),
      qty: map['qty']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
      subTotal: map['subTotal']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromJson(String source) =>
      OrderDetail.fromMap(json.decode(source));
}
