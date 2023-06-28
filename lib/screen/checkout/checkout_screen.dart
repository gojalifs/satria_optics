import 'package:flutter/material.dart';

import '../../model/cart.dart';

enum _PaymentMethod { gopay, ovo, shopeepay }

class CheckoutPage extends StatefulWidget {
  static String routeName = '/checkout';
  final List<Cart> products;

  const CheckoutPage({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  var paymentMethod = _PaymentMethod.ovo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 50),
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping Address',
                          style: TextStyle(color: Colors.white60),
                        ),
                        Divider(),
                        Text(
                          'Recipient Name',
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Phone',
                          style: TextStyle(color: Colors.white60),
                        ),
                        Text(
                          'Street Name',
                          style: TextStyle(color: Colors.white60),
                        ),
                        Text(
                          'Location Detail',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    primary: false,
                    shrinkWrap: true,
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      var cart = widget.products[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                // cart.product.imageUrl![index],
                                cart.product.colors![cart.color],
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cart.product.name!,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      cart.color,
                                      style: const TextStyle(
                                          color: Colors.white54),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'IDR ${cart.product.price}',
                                            style: const TextStyle(
                                              color: Colors.white54,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'x1',
                                            style: TextStyle(
                                                color: Colors.white54),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (widget.products.length != index + 1)
                            const Divider(),
                        ],
                      );
                    },
                  ),
                ),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sub Total'),
                            Text('Sub Total'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping Fee'),
                            Text('Shipping Fee'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount'),
                            Text('Discount'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total'),
                            Text('Total'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Form(
                    child: Column(
                      children: [
                        const Text('Payment Method'),
                        const SizedBox(height: 10),
                        RadioListTile.adaptive(
                          value: _PaymentMethod.gopay,
                          groupValue: paymentMethod,
                          onChanged: (value) {
                            paymentMethod = value!;
                            setState(() {});
                          },
                          title: const Text('Gopay'),
                        ),
                        RadioListTile.adaptive(
                          value: _PaymentMethod.ovo,
                          groupValue: paymentMethod,
                          onChanged: (value) {
                            paymentMethod = value!;
                            setState(() {});
                          },
                          title: const Text('OVO'),
                        ),
                        RadioListTile.adaptive(
                          value: _PaymentMethod.shopeepay,
                          groupValue: paymentMethod,
                          onChanged: (value) {
                            paymentMethod = value!;
                            setState(() {});
                          },
                          title: const Text('Shopeepay'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  /// TODO implement proceed payment navigation
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.red,
                  child: const Center(child: Text('Proceed Payment')),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
