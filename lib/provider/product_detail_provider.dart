import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class FrameDetailProvider extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  XFile? _image;
  String? _imagePath = '';

  XFile? get image => _image;
  String? get imagePath => _imagePath;

  removeImage() {
    _image = null;
    notifyListeners();
  }

  Future<String> getPictCamera() async {
    final pict = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    var filePath = pict!.path;
    var targetPath = '${filePath}_compressed.jpg';
    var compressed = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 25,
    );

    _image = XFile(compressed!.path);
    _imagePath = _image!.path.split('/').last;
    notifyListeners();
    return _imagePath ?? '';
  }

  Future<String> getPictGallery() async {
    final pict = await picker.pickImage(
      source: ImageSource.gallery,
    );
    var filePath = pict!.path;
    var targetPath = '${filePath}_compressed.jpg';
    XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 25,
    );

    _image = XFile(compressed!.path);
    _imagePath = _image!.path.split('/').last;
    notifyListeners();
    return _imagePath ?? '';
  }
}
