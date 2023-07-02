import '../model/address.dart';
import 'firestore_helper.dart';

class AddressHelper extends FirestoreHelper {
  Future<List<Address>> getAddresses() async {
    List<Address> addresses = [];
    var addressRef = db.collection('users').doc(userID).collection('address');
    var data = await addressRef.get();
    for (var element in data.docs) {
      var address = element.data();
      address['id'] = element.id;
      addresses.add(Address.fromMap(address));
    }
    return addresses;
  }

  Future<String> addAddress(Address address) async {
    try {
      var addressRef =
          db.collection('users').doc(userID).collection('address').doc();
      await addressRef.set(address.toMap());
      return addressRef.id;
    } catch (e) {
      throw 'Something error happened';
    }
  }
}
