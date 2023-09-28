import 'package:flutter/foundation.dart';
import 'package:satria_optik/helper/frame_helper.dart';
import 'package:satria_optik/model/glass_frame.dart';

class FrameProvider extends ChangeNotifier {
  FrameHelper frameHelper = FrameHelper();

  GlassFrame? _frame = GlassFrame();
  final List<GlassFrame> _frames = [];
  final List<String> _frameColors = [];
  final List<String> _frameColorImages = [];

  GlassFrame? get frame => _frame;
  List<GlassFrame>? get frames => _frames;
  List<String>? get frameColors => _frameColors;
  List<String>? get frameColorImages => _frameColorImages;

  Future getAllFrames() async {
    await frameHelper.getAllFrame().then((value) {
      _frames.clear();
      for (var frame in value) {
        _frames.add(frame);
      }
      notifyListeners();
    });
  }

  Future<GlassFrame> getFrameDetail(String id) async {
    _frame = await frameHelper.getFrame(id);

    notifyListeners();
    return _frame!;
  }
}
