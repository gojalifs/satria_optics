import 'dart:io';

import 'package:flutter/material.dart';

import '../helper/cart_helper.dart';
import '../model/cart.dart';

class CartProvider extends ChangeNotifier {
  CartHelper cartHelper = CartHelper();
  ConnectionState _state = ConnectionState.none;

  List<Cart> _carts = [];
  List<Cart> get carts => _carts;
  ConnectionState get state => _state;

  Future getCarts() async {
    if (_carts.isNotEmpty) {
      _carts.clear();
    }
    _state = ConnectionState.active;
    _carts = await cartHelper.getCarts();
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future addToCart(Cart cart, File file, bool isUpdate) async {
    var id = await cartHelper.addToCart(cart, file, isUpdate);
    if (!isUpdate) {
      _carts.add(cart);
    }
    cart.id = id;
    notifyListeners();
  }

  Future getCart(Cart cart) async {
    int position = _carts.indexOf(cart);
    _carts[position] = await cartHelper.getCart(cart.id!);
    notifyListeners();
  }

  Future removeFromCart(Cart cart) async {
    await cartHelper.removeFromCart(cart);
    _carts.remove(cart);
    notifyListeners();
  }

  Future removeFromProvider(List<Cart> cart) async {
    cart.map((e) => _carts.remove(e));
    notifyListeners();
  }
}
