import 'package:flutter/material.dart';
import 'package:satria_optik/helper/address_helper.dart';
import 'package:satria_optik/model/address.dart';

class AddressProvider extends ChangeNotifier {
  final AddressHelper _helper = AddressHelper();
  List<Address>? _addresses = [];
  ConnectionState _state = ConnectionState.none;

  List<Address>? get address => _addresses;
  ConnectionState? get state => _state;

  Future getAddresses() async {
    _state = ConnectionState.active;
    _addresses = await _helper.getAddresses();
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future addAddress(Address address) async {
    _state = ConnectionState.active;
    var result = await _helper.addAddress(address);
    _addresses?.add(address.copyWith(id: result));
    _state = ConnectionState.done;
    notifyListeners();
  }
}
