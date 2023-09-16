import 'package:flutter/material.dart';
import 'package:satria_optik/helper/favorite_helper.dart';
import 'package:satria_optik/model/glass_frame.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteHelper _helper = FavoriteHelper();
  ConnectionState _state = ConnectionState.none;

  List<String> _favFramesId = [];
  List<GlassFrame> _favFrames = [];

  ConnectionState get state => _state;
  List<String> get favFramesId => _favFramesId;
  List<GlassFrame> get favFrames => _favFrames;

  Future getFavs() async {
    if (_favFramesId.isNotEmpty) {
      _favFramesId.clear();
    }
    _state = ConnectionState.active;
    _favFramesId = await _helper.getFavoritesId();

    _state = ConnectionState.done;

    notifyListeners();
  }

  Future getFavProducts() async {
    _state = ConnectionState.active;
    try {
      if (_favFramesId.isEmpty) {
        _favFramesId = await _helper.getFavoritesId();
      }
      print(_favFramesId);
      _favFrames = await _helper.getFavoritesFrame(_favFramesId);
    } catch (e) {
      rethrow;
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<bool> updateFavorite(String frameId) async {
    _state = ConnectionState.active;
    bool isAdd = true;
    try {
      if (_favFramesId.contains(frameId)) {
        _favFramesId.remove(frameId);
        isAdd = false;
      } else {
        _favFramesId.add(frameId);
      }

      await _helper.updateFavorite(_favFramesId);
      return isAdd;
    } catch (e) {
      rethrow;
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }
}
