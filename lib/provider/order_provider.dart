import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:satria_optik/helper/order_helper.dart';
import 'package:satria_optik/model/transactions.dart';

class OrderProvider extends ChangeNotifier {
  final OrderHelper _helper = OrderHelper();
  Map<String, dynamic> _status = {};
  ConnectionState _state = ConnectionState.none;
  ConnectionState _individualState = ConnectionState.none;
  List<Transactions>? _orders = [];
  Transactions _order = Transactions();

  ConnectionState get state => _state;
  ConnectionState get individualState => _individualState;
  List<Transactions>? get orders => _orders;
  Transactions get order => _order;

  set order(Transactions order) {
    _order = order;
    notifyListeners();
  }

  Future getOrdersByStatus(status) async {
    _state = ConnectionState.active;
    notifyListeners();
    try {
      _orders = await _helper.getOrders(status);
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future getOrder(String id) async {
    _state = ConnectionState.active;
    _order = await _helper.getOrder(id);
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    _individualState = ConnectionState.active;
    _status = await _helper.getpaymentStatus(paymentId);

    var index = _orders?.indexWhere((element) => element.id == paymentId);
    if (index != null && index != -1) {
      if (_status['status_code'] != '404') {
        _order = _orders![index].copyWith(
          paymentExpiry:
              Timestamp.fromDate(DateTime.parse(_status['expiry_time'])),
        );

        _orders![index] = _order;
      }
    }
    _individualState = ConnectionState.done;
    notifyListeners();
    return _status;
  }

  Future updatePaymentStatus(String transactId, String status,
      {bool? isWallet = false}) async {
    try {
      DateTime expiry = _status['expiry_time'] != null
          ? DateTime.parse(_status['expiry_time'])
          : order.orderMadeTime!
              .toDate()
              .add(Duration(minutes: isWallet! ? 15 : 1440));
      DateTime? paidAt = _status['transaction_status'] == 'success' ||
              _status['transaction_status'] == 'settlement'
          ? DateTime.parse(_status['transaction_time'])
          : null;
      String? orderStatus = _status['transaction_status'] == 'success' ||
              _status['transaction_status'] == 'settlement'
          ? 'Packing'
          : null;
      await _helper.updatePaymentStatus(transactId, status,
          expiryTime: expiry, paymentTime: paidAt, orderStatus: orderStatus);

      var index = _orders?.indexWhere((element) => element.id == transactId);
      if (index != null && index != -1) {
        // if (_status['status_code'] != '404') {
        _order = _orders![index].copyWith(
          paymentStatus: status,
          paymentExpiry: Timestamp.fromDate(expiry),
          paymentMadeTime: paidAt != null ? Timestamp.fromDate(paidAt) : null,
        );

        _orders![index] = _order;
        // }
      }
    } finally {
      notifyListeners();
    }
  }

  Future updateDeliveryStatus(String transactId, String status) async {
    await _helper.updateDeliveryStatus(transactId, status);
    var index = _orders?.indexWhere((element) => element.id == transactId);
    if (index != null && index != -1) {
      var updatedOrder = _orders![index].copyWith(deliveryStatus: status);
      _orders![index] = updatedOrder;
      _order = updatedOrder;
    }

    notifyListeners();
  }
}
