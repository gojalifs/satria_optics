import 'dart:io';

import 'package:flutter/material.dart';

import '../helper/cart_helper.dart';
import '../model/cart.dart';

class CartProvider extends ChangeNotifier {
  CartHelper cartHelper = CartHelper();
  ConnectionState _state = ConnectionState.none;

  bool _isUpdate = false;

  List<Cart>? _carts = [];
  List<Cart>? _checkouts = [];

  double? _totalPrice = 0;

  List<Cart>? get carts => _carts;
  List<Cart>? get checkouts => _checkouts;
  bool get isUpdate => _isUpdate;
  ConnectionState get state => _state;
  double? get totalPrice => _totalPrice;

  setToUpdate(bool isUpdate) {
    _isUpdate = isUpdate;
    notifyListeners();
  }

  setTotal(double total) {
    _totalPrice = total;
    notifyListeners();
  }

  addCheckouts(Cart cart) {
    _checkouts?.add(cart);
    notifyListeners();
  }

  removeCheckouts(Cart cart) {
    _checkouts?.remove(cart);
  }

  Future getCarts() async {
    if (_carts!.isNotEmpty || _checkouts!.isNotEmpty) {
      _carts!.clear();
      _checkouts!.clear();
      _totalPrice = 0;
    }
    _state = ConnectionState.active;
    _carts = await cartHelper.getCarts();
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future addToCart(Cart cart, File file) async {
    await cartHelper.addToCart(cart, file, _isUpdate);
    _isUpdate = false;
    notifyListeners();
  }

  Future getCart(Cart cart) async {
    int position = _carts!.indexOf(cart);
    _carts?[position] = await cartHelper.getCart(cart.id!);
    notifyListeners();
  }

  Future removeFromCart(Cart cart) async {
    await cartHelper.removeFromCart(cart);
    _carts?.remove(cart);
    notifyListeners();
  }
}
