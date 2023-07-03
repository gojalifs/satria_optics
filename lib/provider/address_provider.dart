import 'package:flutter/material.dart';
import 'package:satria_optik/helper/address_helper.dart';
import 'package:satria_optik/model/address.dart';

class AddressProvider extends ChangeNotifier {
  final AddressHelper _helper = AddressHelper();
  ConnectionState _state = ConnectionState.none;
  List<Address>? _addresses = [];
  Address? _selectedAddress;

  ConnectionState? get state => _state;
  List<Address>? get address => _addresses;
  Address? get selectedAddress => _selectedAddress;

  Future getAddresses() async {
    _state = ConnectionState.active;
    _addresses = await _helper.getAddresses();
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future setActiveAddress(int index) async {
    _selectedAddress = _addresses?[index];
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
