import 'package:flutter/material.dart';

import '../model/glass_frame.dart';
import '../screen/product/product_detail/product_detail_screen.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? inputType;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.labelLarge,
      ),
      style: Theme.of(context).textTheme.labelLarge,
      validator: validator,
    );
  }
}

class ProductCard extends StatelessWidget {
  final List<GlassFrame> products;
  final int index;

  const ProductCard({
    Key? key,
    required this.products,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailPage.routeName,
              arguments: products[index]);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Image.network(
                  products[index].imageUrl![0],
                  fit: BoxFit.fill,
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color.fromRGBO(255, 69, 0, 1),
                          ),
                    ),
                    Text(
                      products[index].rating!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.amber,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
