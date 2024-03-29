import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:satria_optik/helper/order_helper.dart';
import 'package:satria_optik/model/transactions.dart';

class OrderProvider extends ChangeNotifier {
  final OrderHelper _helper = OrderHelper();
  Map<String, dynamic> _status = {};
  ConnectionState _state = ConnectionState.none;
  ConnectionState _individualState = ConnectionState.none;

  // List<Transactions>? _orders = [];
  List<Transactions> _waitingPayments = [];
  List<Transactions> _packings = [];
  List<Transactions> _delivering = [];
  List<Transactions> _completed = [];
  List<Transactions> _cancelled = [];
  Transactions _order = Transactions();

  ConnectionState get state => _state;

  ConnectionState get individualState => _individualState;

  // List<Transactions>? get orders => _orders;
  List<Transactions> get waitingPayments => _waitingPayments;

  List<Transactions> get packings => _packings;

  List<Transactions> get delivering => _delivering;

  List<Transactions> get completed => _completed;

  List<Transactions> get cancelled => _cancelled;

  Transactions get order => _order;

  set order(Transactions order) {
    _order = order;
    notifyListeners();
  }

  addToWaitingPayments(Transactions transactions) {
    _waitingPayments.add(transactions);
    notifyListeners();
  }

  Future getOrdersByStatus(String status) async {
    _state = ConnectionState.active;
    notifyListeners();
    try {
      var orders = await _helper.getOrders(status);
      switch (status) {
        case 'waitingPayment':
          _waitingPayments = orders;
          break;
        case 'packing':
          _packings = orders;
          break;
        case 'Shipping':
          _delivering = orders;
          break;
        case 'Done':
          _completed = orders;
          break;
        case 'cancelled':
          _cancelled = orders;
          break;
        default:
      }
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

    if (_status['status_code'] != '404') {
      _order = _order.copyWith(
        paymentExpiry:
            Timestamp.fromDate(DateTime.parse(_status['expiry_time'])),
      );
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
          ? 'packing'
          : null;
      await _helper.updatePaymentStatus(transactId, status,
          expiryTime: expiry, paymentTime: paidAt, orderStatus: orderStatus);

      _order = _order.copyWith(
        paymentStatus: status,
        paymentExpiry: Timestamp.fromDate(expiry),
        paymentMadeTime: paidAt != null ? Timestamp.fromDate(paidAt) : null,
      );
    } finally {
      notifyListeners();
    }
  }

  Future updateDeliveryStatus(String transactId, String status) async {
    await _helper.updateDeliveryStatus(transactId, status);

    _order = _order.copyWith(deliveryStatus: status);

    notifyListeners();
  }

  markAsCompleted() async {
    _state = ConnectionState.active;
    try {
      notifyListeners();
      await _helper.markAsCompleted(_order.id!);
      _delivering.remove(_order);
      _order = _order.copyWith(orderStatus: 'Done');
      _completed.add(_order);
      print('done');
    } catch (e) {
      rethrow;
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }
}
