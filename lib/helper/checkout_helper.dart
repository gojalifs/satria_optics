import '../model/transactions.dart';
import 'firestore_helper.dart';

class CheckoutHelper extends FirestoreHelper {
  Future<String> addTransaction(
      Transactions transaction, List<String> cartId) async {
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

      data['orderMadeTime'] = timestamp;
      data['paymentExpiry'] = DateTime.now().add(const Duration(days: 1));

      data['cartProduct'] = transaction.cartProduct?.map((e) {
        return e.toMap();
      }).toList();
      print(data['orderMadeTime']);
      await checkoutRef.set(data);

      for (var i = 0; i < cartId.length; i++) {
        await db
            .collection('users')
            .doc(userID)
            .collection('carts')
            .doc(cartId[i])
            .delete();
      }

      return checkoutRef.id;
    } catch (e) {
      print(e);
      throw 'something error';
    }
  }

  Future updatePaymentData(
      String transactId, String paymentId, String redirectUrl) async {
    var ref = db
        .collection('users')
        .doc(userID)
        .collection('transactions')
        .doc(transactId);

    await ref.update({
      'paymentId': paymentId,
      'redirectUrl': redirectUrl,
    });
  }
}
