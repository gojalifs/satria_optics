import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik/helper/firestore_helper.dart';
import 'package:satria_optik/model/transactions.dart';

class CheckoutHelper extends FirestoreHelper {
  Future<String> addTransaction(Transactions transaction) async {
    try {
      var checkoutRef =
          db.collection('users').doc(userID).collection('transactions').doc();
      var cartRef = db.collection('users').doc(userID).collection('carts');
      var data = transaction.toMap();
      data['address'] = db
          .collection('users')
          .doc(userID)
          .collection('address')
          .doc(transaction.address!.id);

      data['cartProduct'] =
          transaction.cartProduct?.map((e) => e.toMap()).toList();

      await checkoutRef.set(data);

      for (var cart in transaction.cartProduct!) {
        await cartRef.doc(cart.id).delete();
      }

      return checkoutRef.id;
    } catch (e) {
      throw 'something error';
    }
  }
}
