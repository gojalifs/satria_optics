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
        if (frame.imageUrl == null || frame.imageUrl!.isEmpty) {
          frame = frame.copyWith(imageUrl: ['https://firebasestorage.googleapis.com/v0/b/satria-jaya-optik.appspot.com/o/default%2Fbonbon-boy-with-red-hair-and-glasses.png?alt=media&token=53c99253-a46d-4f31-9851-48b6b76b1d54']);
        }
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
