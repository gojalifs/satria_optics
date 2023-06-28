import 'package:satria_optik/helper/firestore_helper.dart';

import '../model/glass_frame.dart';

class FrameHelper extends FirestoreHelper {
  Future<List<GlassFrame>> getAllFrame() async {
    List<Map<String, dynamic>> frames = [];
    var frameRef = db.collection('products');
    await frameRef.get().then((snapshots) {
      for (var snapshot in snapshots.docs) {
        var data = snapshot.data();
        data['id'] = snapshot.id;
        frames.add(data);
      }
    });
    return frames.map((e) => GlassFrame.fromMap(e)).toList();
  }

  Future<GlassFrame> getFrame(String id) async {
    var frameRef = db.collection('products').doc(id);
    var frameData = await frameRef.get();
    return GlassFrame.fromMap(frameData.data()!);
  }
}
