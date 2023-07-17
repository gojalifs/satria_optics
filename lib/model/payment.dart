// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Payment {
  final TransactionDetails transaction_details;
  final CustomerDetails customer_details;

  Payment(this.transaction_details, this.customer_details);

  Map<String, dynamic> toMap() {
    return {
      'transaction_details': transaction_details.toMap(),
      'customer_details': customer_details.toMap(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      TransactionDetails.fromMap(map['transaction_details']),
      CustomerDetails.fromMap(map['customer_details']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source));
}

class TransactionDetails {
  final String order_id;
  final String gross_amount;

  TransactionDetails(this.order_id, this.gross_amount);

  Map<String, dynamic> toMap() {
    return {
      'order_id': order_id,
      'gross_amount': gross_amount,
    };
  }

  factory TransactionDetails.fromMap(Map<String, dynamic> map) {
    return TransactionDetails(
      map['order_id'] ?? '',
      map['gross_amount'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionDetails.fromJson(String source) =>
      TransactionDetails.fromMap(json.decode(source));
}

class CustomerDetails {
  final String first_name;
  final String last_name;
  final String email;
  final String phone;
  CustomerDetails({
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

  factory CustomerDetails.fromMap(Map<String, dynamic> map) {
    return CustomerDetails(
      first_name: map['first_name'] ?? '',
      last_name: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDetails.fromJson(String source) =>
      CustomerDetails.fromMap(json.decode(source));
}
