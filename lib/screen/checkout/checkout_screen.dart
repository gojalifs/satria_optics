import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../helper/midtrans_helper.dart';
import '../../model/cart.dart';
import '../../model/transactions.dart';
import '../../provider/address_provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/transaction_provider.dart';
import '../payment/payment_webview.dart';
import '../profile/address/address_screen.dart';
import 'select_address_screen.dart';

class CheckoutPage extends StatelessWidget {
  static String routeName = '/checkout';
  final List<Cart> products;

  const CheckoutPage({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MidtransHelper midtransHelper = MidtransHelper();
    int total = products
            .map((e) => e.totalPrice)
            .reduce((value, element) => value! + element!)
            ?.toInt() ??
        0;
    int shipFee = 0;
    int discount = 0;
    int grandTotal = total + shipFee + discount;

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
                              Navigator.of(context).pushNamed(
                                AddressPage.routeName,
                                arguments: true,
                              );
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
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var cart = products[index];
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
                                            formatToRupiah(cart.product.price!),
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
                              Text(formatToRupiah(cart.lens.price!)),
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
                              Text(formatToRupiah(cart.totalPrice!.toInt())),
                            ],
                          ),
                          if (products.length != index + 1)
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
                              Text(formatToRupiah(total)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping Fee'),
                              Text(formatToRupiah(shipFee)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Discount'),
                              Text(formatToRupiah(discount)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Grand Total'),
                              Text(formatToRupiah(grandTotal)),
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
              child: Consumer2<AddressProvider, TransactionProvider>(
                builder: (context, addressProf, transactProf, child) {
                  return InkWell(
                    onTap: addressProf.selectedAddress == null
                        ? null
                        : () async {
                            var order = Transactions(
                              address: addressProf.selectedAddress,
                              cartProduct: products,
                              discount: discount,
                              shipper: '',
                              shippingFee: shipFee,
                              subTotal: total,
                              total: grandTotal,
                            );

                            if (context.mounted) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return LoadingAnimationWidget
                                      .threeArchedCircle(
                                          color: Colors.white, size: 25);
                                },
                              );
                            }

                            var orderId =
                                await transactProf.addTransaction(order);
                            await midtransHelper
                                .getTransactToken(orderId, grandTotal)
                                .then(
                              (value) {
                                Navigator.of(context).pushNamed(
                                  PaymentWebView.routeName,
                                  arguments: value,
                                );
                              },
                            ).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$error'),
                                ),
                              );
                            });
                          },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: addressProf.selectedAddress == null
                          ? Colors.white38
                          : Colors.red,
                      child: const Center(child: Text('Proceed To Payment')),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatToRupiah(int data) {
    NumberFormat formatToRupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
    );

    return formatToRupiah.format(data);
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
            formatGrandTotalToRupiah(data),
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white54),
          ),
        )
      ],
    );
  }

  String formatGrandTotalToRupiah(String data) {
    NumberFormat formatToRupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
    );
    var price = double.parse(data) * 50000;
    return formatToRupiah.format(price);
  }
}
