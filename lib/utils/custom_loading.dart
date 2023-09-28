import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingAnimation {
  static show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => LoadingAnimationWidget.threeArchedCircle(
        color: Colors.white,
        size: 25,
      ),
    );
  }

  static hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
