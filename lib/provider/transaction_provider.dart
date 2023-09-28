import 'package:flutter/material.dart';
import 'package:satria_optik/helper/checkout_helper.dart';
import 'package:satria_optik/model/transactions.dart';

class TransactionProvider extends ChangeNotifier {
  final CheckoutHelper helper = CheckoutHelper();
  ConnectionState _state = ConnectionState.none;
  final List<Transactions> _transactions = [];
  final int _shippingFee = 0;
  final int _discount = 0;
  int _grandTotal = 0;

  ConnectionState get state => _state;
  List<Transactions>? get transactions => _transactions;
  int get shippingFee => _shippingFee;
  int get discount => _discount;
  int get grandTotal => _grandTotal;

  void addGrandTotal(int total) {
    _grandTotal += total;
  }

  Future<String> addTransaction(
      Transactions transaction, List<String> cartId) async {
    _state = ConnectionState.active;
    var transactId = await helper.addTransaction(transaction, cartId);
    _state = ConnectionState.done;
    notifyListeners();
    return transactId;
  }

  Future updatePaymentData(
      String transactId, String paymentId, String redirectUrl) async {
    await helper.updatePaymentData(transactId, paymentId, redirectUrl);
  }
}
