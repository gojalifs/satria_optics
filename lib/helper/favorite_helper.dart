import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik/helper/firestore_helper.dart';
import 'package:satria_optik/helper/frame_helper.dart';
import 'package:satria_optik/model/favorite.dart';

class FavoriteHelper extends FirestoreHelper {
  Future<List<Favorite>> getFavorites() async {
    List<Favorite> favs = [];

    final favRef =
        db.collection("products").where("favoritedBy.$userID", isEqualTo: true);
    var favorites = await favRef.get();
    FrameHelper frameHelper = FrameHelper();
    for (var element in favorites.docs) {
      var favFrame = await frameHelper.getFrame(element.id);

      favs.add(Favorite.fromFirestore(
        element,
        favFrame,
      ));
    }

    return favs;
  }

  Future<bool> addToFavorite(String frameId) async {
    try {
      final favRef = db.collection('products').doc(frameId);
      await favRef.set(
        {
          'favoritedBy': {userID: true},
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      throw 'Something error happened';
    }
  }

  Future removeFromFavorite(String frameId) async {
    try {
      final favRef = db.collection('products').doc(frameId);
      await favRef.set(
        {
          'favoritedBy': {userID: false},
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      throw 'Something error happened';
    }
  }
}
