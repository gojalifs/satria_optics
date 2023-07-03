// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Payment {
  final Transaction_details transaction_details;
  final Customer_details customer_details;

  Payment(this.transaction_details, this.customer_details);

  Map<String, dynamic> toMap() {
    return {
      'transaction_details': transaction_details.toMap(),
      'customer_details': customer_details.toMap(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      Transaction_details.fromMap(map['transaction_details']),
      Customer_details.fromMap(map['customer_details']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source));
}

class Transaction_details {
  final String order_id;
  final String gross_amount;

  Transaction_details(this.order_id, this.gross_amount);

  Map<String, dynamic> toMap() {
    return {
      'order_id': order_id,
      'gross_amount': gross_amount,
    };
  }

  factory Transaction_details.fromMap(Map<String, dynamic> map) {
    return Transaction_details(
      map['order_id'] ?? '',
      map['gross_amount'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction_details.fromJson(String source) =>
      Transaction_details.fromMap(json.decode(source));
}

class Customer_details {
  final String first_name;
  final String last_name;
  final String email;
  final String phone;
  Customer_details({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
    };
  }

  factory Customer_details.fromMap(Map<String, dynamic> map) {
    return Customer_details(
      first_name: map['first_name'] ?? '',
      last_name: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer_details.fromJson(String source) =>
      Customer_details.fromMap(json.decode(source));
}
