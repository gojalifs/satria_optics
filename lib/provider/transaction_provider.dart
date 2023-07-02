import 'package:flutter/material.dart';
import 'package:satria_optik/helper/checkout_helper.dart';
import 'package:satria_optik/model/transactions.dart';

class TransactionProvider extends ChangeNotifier {
  final CheckoutHelper helper = CheckoutHelper();
  ConnectionState _state = ConnectionState.none;
  List<Transactions>? _transactions = [];
  String? _paymentMethod;

  ConnectionState get state => _state;
  List<Transactions>? get transactions => _transactions;
  String? get paymentMethod => _paymentMethod;

  setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future addTransaction(Transactions transaction) async {
    _state = ConnectionState.active;
    await helper.addTransaction(transaction);
    _state = ConnectionState.done;
    notifyListeners();
  }
}
