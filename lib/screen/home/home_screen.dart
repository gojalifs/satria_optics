import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/frames_provider.dart';

import '../../provider/user_provider.dart';
import 'recommended_product_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<FrameProvider>(context, listen: false).getAllFrames();
      Provider.of<UserProvider>(context, listen: false).getUser();
    });
    return Consumer<FrameProvider>(
      builder: (context, value, child) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/banner.png',
            height: 182,
          ),
          const SizedBox(height: 20),
          RecommendedWidget(
            products: value.frames!,
            title: 'Big Discount Ever',
          ),
          RecommendedWidget(
            products: value.frames!,
            title: 'New on Satria Optik',
          ),
          RecommendedWidget(
            products: value.frames!,
            title: 'Popular Right Now',
          ),
        ],
      ),
    );
  }
}
