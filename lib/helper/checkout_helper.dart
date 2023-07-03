import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik/helper/firestore_helper.dart';
import 'package:satria_optik/model/transactions.dart';

class CheckoutHelper extends FirestoreHelper {
  Future<String> addTransaction(Transactions transaction) async {
    try {
      var checkoutRef =
          db.collection('users').doc(userID).collection('transactions').doc();
      var data = transaction.toMap();
      data['address'] = db
          .collection('users')
          .doc(userID)
          .collection('address')
          .doc(transaction.address!.id);

      data['cartProduct'] = transaction.cartProduct?.map(
        (e) {
          return db
              .collection('users')
              .doc(userID)
              .collection('carts')
              .doc(e.id);
        },
      ).toList() as List<DocumentReference<Map<String, dynamic>>>;

      await checkoutRef.set(data);
      return checkoutRef.id;
    } catch (e) {
      throw 'something error';
    }
  }
}
