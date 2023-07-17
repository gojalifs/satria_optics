import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:satria_optik/helper/firestore_helper.dart';

class MidtransHelper extends FirestoreHelper {
  Map<String, dynamic> key = {};

  Future<String> getApiKey() async {
    var apiRef = db.collection('midtrans-api-rhs').doc('key');
    var docs = await apiRef.get();
    key = docs.data() ?? {};

    return key['server'];
  }

  Future<Map<String, dynamic>> getTransactToken(
    String orderId,
    int amount,
  ) async {
    /// TODO change this to production
    /// this is sandbox url
    String serverKey = await getApiKey();
    var baseUrl = 'https://app.sandbox.midtrans.com/snap/v1/transactions';
    try {
      var url = Uri.parse(baseUrl);
      var paymentData = {
        "transaction_details": {"order_id": orderId, "gross_amount": amount},
        "customer_details": {
          "first_name": "budi",
          "last_name": "pratama",
          "email": "budi.pra@example.com",
          "phone": "08111222333"
        }
      };
      final resp = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Basic ${base64Encode(serverKey.codeUnits)}",
        },
        body: jsonEncode(paymentData),
      );
      Map<String, dynamic> data = jsonDecode(resp.body);
      if (resp.statusCode == 201) {
        return data;
      } else if (resp.statusCode == 401) {
        throw 'error getting token data';
      } else if (resp.statusCode > 401 && resp.statusCode < 500) {
        throw 'error in data sent';
      } else {
        throw 'Something error on the server';
      }
    } catch (e) {
      throw 'Something error happened';
    }
  }
}
