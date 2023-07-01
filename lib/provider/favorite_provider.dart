import 'package:flutter/material.dart';
import 'package:satria_optik/helper/favorite_helper.dart';
import 'package:satria_optik/model/favorite.dart';
import 'package:satria_optik/model/glass_frame.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteHelper _helper = FavoriteHelper();
  ConnectionState _state = ConnectionState.none;
  List<Favorite>? _favorites = [];
  List<GlassFrame>? _favFrames = [];

  ConnectionState get state => _state;
  List<Favorite>? get favorites => _favorites;
  List<GlassFrame>? get favFrames => _favFrames;

  Future getFavs() async {
    if (_favorites!.isNotEmpty) {
      _favorites!.clear();
      _favFrames!.clear();
    }
    _state = ConnectionState.active;
    _favorites = await _helper.getFavorites();

    _favFrames = _favorites?.map((e) => e.frame!).toList();

    _state = ConnectionState.done;

    notifyListeners();
  }

  Future<bool> addFavorite(String frameId) async {
    try {
      await _helper.addToFavorite(frameId);
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future removeFavorite(String frameId) async {
    try {
      await _helper.removeFromFavorite(frameId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
