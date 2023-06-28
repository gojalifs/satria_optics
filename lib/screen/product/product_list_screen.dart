import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/provider/frames_provider.dart';
import 'package:satria_optik/utils/common_widget.dart';

import '../../model/glass_frame.dart';

class ProductListPage extends StatelessWidget {
  static String routeName = '/product-list';
  final String title;
  final Future categoryProvider;

  const ProductListPage({
    Key? key,
    required this.title,
    required this.categoryProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: EasyRefresh(
        onRefresh: () {
          return Provider.of<FrameProvider>(context, listen: false)
              .getAllFrames();
        },
        onLoad: () {
          return Provider.of<FrameProvider>(context, listen: false)
              .getAllFrames();
        },
        refreshOnStart: true,
        child: Consumer<FrameProvider>(
          builder: (context, value, child) {
            List<GlassFrame> frames = value.frames ?? [];
            var i = value.frames!.length;

            return GridView.builder(
              itemCount: i,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return ProductCard(products: frames, index: index);
              },
            );
          },
        ),
      ),
    );
  }
}
