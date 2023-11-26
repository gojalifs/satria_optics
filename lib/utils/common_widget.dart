import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satria_optik/utils/custom_function.dart';

import '../model/address.dart';
import '../model/glass_frame.dart';
import '../screen/product/product_detail/product_detail_screen.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.inputType,
    this.inputFormatters,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
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
                child: products[index].imageUrl != null
                    ? Image.network(
                        products[index].imageUrl![0],
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                            child: child,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        fit: BoxFit.fill,
                      )
                    : const Icon(Icons.image_not_supported_rounded),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    products[index].name ?? 'No Title',
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Format.formatToRupiah(products[index].price ?? 0),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color.fromRGBO(255, 69, 0, 1),
                          ),
                    ),
                    Text(
                      products[index].rating ?? '',
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

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
  });

  final Address? address;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address!.receiverName,
              style: const TextStyle(
                fontSize: 21,
              ),
            ),
            const Divider(),
            Text(
              address!.phone,
              style: const TextStyle(color: Colors.white60),
            ),
            Text(
              '''${address!.street}, ${address!.village}, '''
              '''${address!.subdistrict}''',
              style: const TextStyle(color: Colors.white60),
            ),
            Text(
              '${address!.city}, ${address!.province} ${address!.postalCode}',
              style: const TextStyle(color: Colors.white60),
            )
          ],
        ),
      ),
    );
  }
}
