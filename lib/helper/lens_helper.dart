import 'package:satria_optik/helper/firestore_helper.dart';

import '../model/lens.dart';

class LensHelper extends FirestoreHelper {
  Future<List<Lens>> getLenses() async {
    List<Lens> lenses = [];
    var lensRef = db.collection('lens');
    await lensRef.get().then((snapshots) {
      for (var snapshot in snapshots.docs) {
        var data = snapshot.data();
        data['id'] = snapshot.id;
        lenses.add(Lens.fromMap(data));
      }
    });
    return lenses;
  }
}
