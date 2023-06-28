import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik/helper/firestore_helper.dart';

import '../model/cart.dart';
import '../model/glass_frame.dart';
import '../model/lens.dart';

class CartHelper extends FirestoreHelper {
  Future<List<Cart>> getCarts() async {
    List<Cart> carts = [];
    var cartRef = db.collection('users').doc(userID).collection('carts').get();
    var data = await cartRef;
    for (var snapshot in data.docs) {
      var cartData = snapshot.data();
      var lensRef = cartData['lens'] as DocumentReference<Map<String, dynamic>>;
      var frameRef =
          cartData['frame'] as DocumentReference<Map<String, dynamic>>;

      // Fetch lens document
      var lensSnapshot = await lensRef.get().then((value) {
        var data = value.data();
        data?['id'] = value.id;
        return data;
      });
      var lensData = lensSnapshot;

      // Fetch frame document
      var frameSnapshot = await frameRef.get().then((value) {
        var data = value.data();
        data?['id'] = value.id;
        return data;
      });
      var frameData = frameSnapshot;

      // Create Cart object and add to carts list
      carts.add(
        Cart(
          id: cartData['id'],
          product: GlassFrame.fromMap(frameData!),
          lens: Lens.fromMap(lensData!),
          color: cartData['color'],
          minusData: MinusData(
            leftEyeMinus: cartData['leftEyeMinus'],
            rightEyeMinus: cartData['rightEyeMinus'],
            leftEyePlus: cartData['leftEyePlus'],
            rightEyePlus: cartData['rightEyePlus'],
            recipePath: cartData['recipePath'],
          ),
          totalPrice: cartData['totalPrice'],
        ),
      );
    }
    return carts;
  }

  Future<Cart> getCart(String cartId) async {
    try {
      var cartRef =
          db.collection('users').doc(userID).collection('carts').doc(cartId);
      var cartData = await cartRef.get().then((value) {
        var data = value.data();
        data?['id'] = value.id;
        return data;
      });

      var lensRef = cartData?['lens'];
      var frameRef = cartData?['frame'];
      // Fetch frame document
      var frameData = await frameRef.get().then((value) {
        var data = value.data();
        data?['id'] = value.id;
        return data;
      });

      // Fetch lens document
      var lensData = await lensRef.get().then((value) {
        var data = value.data();
        data?['id'] = value.id;
        return data;
      });

      Cart cart = Cart(
        id: cartData?['id'],
        product: GlassFrame.fromMap(frameData!),
        lens: Lens.fromMap(lensData!),
        color: cartData?['color'],
        minusData: MinusData(
          leftEyeMinus: cartData?['leftEyeMinus'],
          rightEyeMinus: cartData?['rightEyeMinus'],
          leftEyePlus: cartData?['leftEyePlus'],
          rightEyePlus: cartData?['rightEyePlus'],
          recipePath: cartData?['recipePath'],
        ),
        totalPrice: cartData?['totalPrice'],
      );

      return cart;
    } catch (e) {
      throw 'Something error happened';
    }
  }

  Future addToCart(Cart cart, File file, bool isUpdate) async {
    DocumentReference<Map<String, dynamic>> cartRef;
    if (isUpdate) {
      cartRef =
          db.collection('users').doc(userID).collection('carts').doc(cart.id);
    } else {
      cartRef = db.collection('users').doc(userID).collection('carts').doc();
    }
    var docId = cartRef.id;

    Map<String, dynamic> cartData = {
      'id': docId,
      'frame': db.collection('products').doc(cart.product.id),
      'lens': db.collection('lens').doc(cart.lens.id),
      'color': cart.color,
      'leftEyeMinus': cart.minusData?.leftEyeMinus,
      'rightEyeMinus': cart.minusData?.rightEyeMinus,
      'leftEyePlus': cart.minusData?.leftEyePlus,
      'rightEyePlus': cart.minusData?.rightEyePlus,
      'totalPrice': cart.totalPrice,
      'recipePath': '',
    };

    await cartRef
        .set(cartData, SetOptions(merge: true))
        .onError((error, stackTrace) {
      throw 'error getting data';
    });

    if (file.existsSync()) {
      try {
        var uploadSnapshot = await storageRef
            .child('recipe_carts/$userID/${cart.minusData!.recipePath}')
            .putFile(file);
        String imageUrl = await uploadSnapshot.ref.getDownloadURL();

        cartRef.update({'recipePath': imageUrl});
      } catch (e) {
        await db
            .collection('users')
            .doc(userID)
            .collection('carts')
            .doc(docId)
            .delete();
        throw 'error while adding to cart';
      }
    }
  }

  Future removeFromCart(Cart cart) async {
    try {
      await db
          .collection('users')
          .doc(userID)
          .collection('carts')
          .doc(cart.id)
          .delete();

      if (cart.minusData?.recipePath != null &&
          cart.minusData!.recipePath!.isNotEmpty) {
        await storageRef
            .child('recipe_carts')
            .child(userID!)
            .child(cart.minusData!.recipePath!)
            .delete();
      }
    } catch (e) {
      throw 'Error deleting item from cart. code $e';
    }
  }
}
