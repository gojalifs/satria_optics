import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik/helper/firestore_helper.dart';
import 'package:satria_optik/helper/midtrans_helper.dart';
import 'package:satria_optik/model/transactions.dart';
import 'package:http/http.dart' as http;

class OrderHelper extends FirestoreHelper {
  Future<List<Transactions>> getOrders(status) async {
    List<Transactions> orders = [];
    var ordersRef =
        db.collection('users').doc(userID).collection('transactions');
    var query = await ordersRef
        .where('orderStatus', isEqualTo: status)
        .orderBy('orderMadeTime', descending: true)
        .get();

    for (var element in query.docs) {
      var data = element.data();
      data['id'] = element.id;
      var address = data['address'] as DocumentReference<Map<String, dynamic>>;
      data['address'] = await address.get().then((value) => value.data());

      orders.add(Transactions.fromMap(data));
    }
    return orders;
  }

  Future<Transactions> getOrder(String id) async {
    Map<String, dynamic> orderMap = {};
    var orderRef =
        db.collection('users').doc(userID).collection('transactions').doc(id);
    var data = await orderRef.get();
    var address = data['address'] as DocumentReference<Map<String, dynamic>>;
    orderMap = data.data()!;
    orderMap['id'] = data.id;
    orderMap['address'] = await address.get().then((value) => value.data());

    return Transactions.fromMap(orderMap);
  }

  Future<Map<String, dynamic>> getpaymentStatus(String paymentId) async {
    String serverKey = await MidtransHelper().getApiKey();
    Map<String, dynamic> paymentStatus = {};
    var url =
        Uri.parse('https://api.sandbox.midtrans.com/v2/$paymentId/status');
    var resp = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Basic ${base64Encode(serverKey.codeUnits)}",
      },
    );
    paymentStatus = jsonDecode(resp.body);
    return paymentStatus;
  }

  Future updatePaymentStatus(
    String transactId,
    String status, {
    DateTime? expiryTime,
    DateTime? paymentTime,
    String? orderStatus,
  }) async {
    var orderRef = db
        .collection('users')
        .doc(userID)
        .collection('transactions')
        .doc(transactId);
    try {
      await orderRef.update({
        'paymentStatus': status,
        'paymentExpiry': expiryTime,
        'paymentMadeTime': paymentTime,
        'orderStatus': orderStatus,
      });
    } catch (e) {
      throw ('Something Error Happened');
    }
  }

  Future updateDeliveryStatus(String transactId, String status) async {
    var orderRef = db
        .collection('users')
        .doc(userID)
        .collection('transactions')
        .doc(transactId);
    try {
      await orderRef.update({'deliveryStatus': status});
    } catch (e) {
      throw 'Something error happened';
    }
  }
}
