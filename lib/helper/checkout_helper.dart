import 'package:satria_optik/helper/firestore_helper.dart';
import 'package:satria_optik/model/transactions.dart';

class CheckoutHelper extends FirestoreHelper {
  Future addTransaction(Transactions transaction) async {
    var checkoutRef =
        db.collection('users').doc(userID).collection('transactions').doc();
    await checkoutRef.set(transaction.toMap());
    return checkoutRef.id;
  }
}
