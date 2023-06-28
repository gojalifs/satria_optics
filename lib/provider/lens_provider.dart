import 'package:flutter/foundation.dart';
import 'package:satria_optik/helper/lens_helper.dart';
import 'package:satria_optik/model/lens.dart';

class LensProvider extends ChangeNotifier {
  List<Lens> _lens = [];

  List<Lens> get lens => _lens;

  Future getLens() async {
    LensHelper lensHelper = LensHelper();
    var lenses = await lensHelper.getLenses();
    _lens = lenses;
    notifyListeners();
  }
}
