import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:satria_optik/helper/firestore_helper.dart';
import 'package:satria_optik/model/glass_frame.dart';

class FavoriteHelper extends FirestoreHelper {
  Future<List<String>> getFavoritesId() async {
    try {
      final userRef = db.collection('users').doc(userID);

      var user = await userRef.get();
      var userData = user.data();
      List<String> favData = [];
      if (userData?['favorites'] != null) {
        favData =
            (userData?['favorites'] as List).map((e) => e.toString()).toList();
      }

      return favData;
    } catch (e, s) {
      debugPrint(s.toString());
      throw 'Error Happened. . .';
    }
  }

  Future<List<GlassFrame>> getFavoritesFrame(List<String> favsId) async {
    try {
      List<GlassFrame> favs = [];
      final ref = db.collection('products');
      var data = await ref.where(FieldPath.documentId, whereIn: favsId).get();

      for (var element in data.docs) {
        var frame = element.data();
        frame['id'] = element.id;
        favs.add(GlassFrame.fromMap(frame));
      }

      return favs;
    } catch (e) {
      throw 'Error Happened. . .';
    }
  }

  Future<bool> updateFavorite(List<String> favorites) async {
    try {
      final ref = db.collection('users').doc(userID);
      await ref.set(
        {
          'favorites': favorites,
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      throw 'Something error happened';
    }
  }
}
