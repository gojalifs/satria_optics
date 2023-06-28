import 'package:flutter/material.dart';

import '../../model/glass_frame.dart';

class PromotionPage extends StatelessWidget {
  static String routeName = '/promotion';
  final String title;
  final List<GlassFrame> products;

  const PromotionPage({
    Key? key,
    required this.title,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.network(
                        products[index].imageUrl![0],
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          products[index].name!,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${products[index].price}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            products[index].rating!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
