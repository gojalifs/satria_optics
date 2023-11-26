import 'package:flutter/material.dart';

import '../../model/glass_frame.dart';
import '../../utils/common_widget.dart';
import '../promo/promotion_screen.dart';

class RecommendedWidget extends StatelessWidget {
  const RecommendedWidget({
    Key? key,
    required this.products,
    required this.title,
  }) : super(key: key);

  final List<GlassFrame> products;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 15),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 15),
        SizedBox(
          height: 176,
          child: Stack(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                primary: false,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 200,
                    child: ProductCard(
                      products: products,
                      index: index,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Card(
                  color: const Color.fromRGBO(251, 18, 16, 1),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PromotionPage.routeName,
                        arguments: {
                          'title': title,
                          'products': products,
                        },
                      );
                    },
                    child: const Icon(
                      Icons.navigate_next_rounded,
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
