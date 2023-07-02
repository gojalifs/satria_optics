import 'package:flutter/material.dart';
import 'package:satria_optik/helper/favorite_helper.dart';
import 'package:satria_optik/model/favorite.dart';
import 'package:satria_optik/model/glass_frame.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteHelper _helper = FavoriteHelper();
  ConnectionState _state = ConnectionState.none;

  List<GlassFrame>? _favFrames = [];

  ConnectionState get state => _state;
  List<GlassFrame>? get favFrames => _favFrames;

  Future getFavs() async {
    if (favFrames!.isNotEmpty) {
      _favFrames!.clear();
    }
    _state = ConnectionState.active;
    List<Favorite>? result = await _helper.getFavorites();

    _favFrames = result.map((e) => e.frame!).toList();

    _state = ConnectionState.done;

    notifyListeners();
  }

  Future<bool> addFavorite(GlassFrame frame) async {
    try {
      await _helper.addToFavorite(frame.id!);
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future removeFavorite(GlassFrame frame) async {
    try {
      await _helper.removeFromFavorite(frame.id!);
      _favFrames?.remove(frame);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
