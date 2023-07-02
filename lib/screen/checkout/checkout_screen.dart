import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/provider/address_provider.dart';
import 'package:satria_optik/provider/cart_provider.dart';
import 'package:satria_optik/provider/transaction_provider.dart';
import 'package:satria_optik/screen/checkout/select_address_screen.dart';

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
  String? paymentMethod;
  double total = 0;

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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<AddressProvider>(
                      builder: (context, value, child) {
                        if (value.selectedAddress == null) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SelectAddressSPage.routeName);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: ListTile(
                                trailing: Icon(Icons.navigate_next_rounded),
                                title: Text('Select address here. . .'),
                              ),
                            ),
                          );
                        }
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(SelectAddressSPage.routeName);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.selectedAddress!.receiverName,
                                    style:
                                        const TextStyle(color: Colors.white60),
                                  ),
                                  const Divider(),
                                  Text(
                                    value.selectedAddress!.phone,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    value.selectedAddress!.street,
                                    style:
                                        const TextStyle(color: Colors.white60),
                                  ),
                                  Text(
                                    '${value.selectedAddress!.detail} jbferwfbjkesn fjkasfnj',
                                    style:
                                        const TextStyle(color: Colors.white60),
                                  ),
                                  Text(
                                    value.selectedAddress!.city,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Align(
                              alignment: Alignment.topRight,
                              child: Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                message: 'Tap to change your address',
                                child: Icon(Icons.help_rounded),
                              ),
                            )
                          ],
                        );
                      },
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
                      total += cart.totalPrice!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(cart.lens.name!),
                              Text(cart.lens.price.toString()),
                            ],
                          ),
                          if (cart.minusData?.leftEyeMinus != null &&
                              cart.minusData!.leftEyeMinus!.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _MinusDataRow(
                                    data: cart.minusData!.leftEyeMinus!,
                                    title: 'Left Eye Minus',
                                  ),
                                  _MinusDataRow(
                                    data: cart.minusData!.rightEyeMinus!,
                                    title: 'Right Eye Minus',
                                  ),
                                  _MinusDataRow(
                                    data: cart.minusData!.leftEyePlus!,
                                    title: 'Left Eye Plus',
                                  ),
                                  _MinusDataRow(
                                    data: cart.minusData!.rightEyePlus!,
                                    title: 'Right Eye Plus',
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sub Total'),
                              Text('${cart.totalPrice}'),
                            ],
                          ),
                          if (widget.products.length != index + 1)
                            const Divider(height: 36),
                        ],
                      );
                    },
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<CartProvider>(
                      builder: (context, value, child) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total'),
                              Text('$total'),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipping Fee'),
                              Text('0'),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount'),
                              Text('0'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Grand Total'),
                              Text('$total'),
                            ],
                          ),
                        ],
                      ),
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
                  child: const Center(child: Text('Proceed To Payment')),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MinusDataRow extends StatelessWidget {
  final String data;
  final String title;

  const _MinusDataRow({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(title)),
        Expanded(
          child: Text(data),
        ),
        Expanded(
          flex: 2,
          child: Text(
            formatToRupiah(data),
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white54),
          ),
        )
      ],
    );
  }

  String formatToRupiah(String data) {
    NumberFormat formatToRupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'IDR ',
    );
    var price = double.parse(data) * 50000;
    return formatToRupiah.format(price);
  }
}
