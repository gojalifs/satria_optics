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
      _favFramesId = await _helper.getFavoritesId();
      if (_favFramesId.isEmpty) {
        return;
      }
      _favFrames = await _helper.getFavoritesFrame(_favFramesId);
    } catch (e) {
      rethrow;
    } finally {
      _state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<bool> updateFavorite(GlassFrame frame) async {
    _state = ConnectionState.active;
    bool isAdd = true;
    try {
      if (_favFrames.contains(frame)) {
        _favFramesId.remove(frame.id);
        _favFrames.remove(frame);
        isAdd = false;
      } else {
        _favFramesId.add(frame.id!);
        _favFrames.add(frame);
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
