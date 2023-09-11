import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/cart.dart';
import '../../provider/cart_provider.dart';
import '../../provider/lens_provider.dart';
import '../checkout/checkout_screen.dart';
import '../product/product_detail/product_bottom_sheet.dart';
import '../product/product_detail/product_detail_screen.dart';

class CartPage extends StatelessWidget {
  static String routeName = '/cart';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    int total = 0;
    NumberFormat formatToRupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'IDR',
    );

    List<Cart> checkoutList = [];

    Provider.of<LensProvider>(context, listen: false).getLens();
    Provider.of<CartProvider>(context, listen: false).getCarts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SafeArea(
        child: EasyRefresh(
          onRefresh: () =>
              Provider.of<CartProvider>(context, listen: false).getCarts(),
          refreshOnStart: true,
          child: Stack(
            children: [
              Consumer<CartProvider>(
                builder: (context, cartProv, child) {
                  if (cartProv.state == ConnectionState.active) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (cartProv.carts!.isEmpty) {
                    return Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: const [
                          Center(
                            child: Text('Your cart is empty'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: cartProv.carts?.length ?? 0,
                    itemBuilder: (context, index) {
                      var cart = cartProv.carts![index];

                      int subTotal = cart.totalPrice!.toInt();

                      String formattedSubTotal =
                          formatToRupiah.format(subTotal);

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ProductDetailPage.routeName,
                            arguments: cart.product,
                          );
                        },
                        child: Card(
                          child: Row(
                            children: [
                              Checkbox.adaptive(
                                value: cart.isChecked,
                                onChanged: (value) {
                                  if (value!) {
                                    checkoutList.add(cart);
                                    total += cart.totalPrice?.toInt() ?? 0;
                                    cartProv.setTotal(total.toDouble());
                                    cartProv.addCheckouts(cart);
                                  } else {
                                    checkoutList.remove(cart);
                                    total -= cart.totalPrice?.toInt() ?? 0;
                                    cartProv.setTotal(total.toDouble());
                                    cartProv.removeCheckouts(cart);
                                  }
                                  cart.isChecked = !cart.isChecked!;
                                },
                              ),
                              const SizedBox(width: 10),
                              Image.network(
                                cart.product.colors![0].url!,
                                width: 75,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_rounded);
                                },
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cart.product.name!,
                                      style: const TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(
                                      '${cart.product.price}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      cart.color,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          cart.lens.name!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          ' IDR${cart.lens.price}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text(
                                          'Eyes Condition',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        cart.minusData?.leftEyeMinus != null &&
                                                cart.minusData!.leftEyeMinus!
                                                    .isNotEmpty
                                            ? const Text('Minus/Plus')
                                            : const Text('Normal'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Sub Total : '),
                                        Text(formattedSubTotal)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ProductDetailBottomSheet(
                                  frame: cart.product,
                                  colorName: cart.product.colors!
                                      .map((e) => e.name!)
                                      .toList(),
                                  page: 'cart',
                                  cart: cart,
                                  color: cart.color,
                                  lensType: cart.lens,
                                  isMinus: cart.minusData != null &&
                                          cart.minusData!.leftEyeMinus!
                                              .isNotEmpty
                                      ? true
                                      : false,
                                  minusData: cart.minusData,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Consumer<CartProvider>(
                            builder: (context, value, child) {
                              var totalPrice =
                                  formatToRupiah.format(value.totalPrice);
                              return Text(
                                'Total $totalPrice',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer<CartProvider>(
                        builder: (context, value, child) {
                          return InkWell(
                            onTap: value.checkouts!.isEmpty
                                ? null
                                : () {
                                    Navigator.of(context).pushNamed(
                                      CheckoutPage.routeName,
                                      arguments: value.checkouts,
                                    );
                                  },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: checkoutList.isEmpty
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                              child: const Center(
                                child: Text(
                                  'Checkout',
                                ),
                              ),
                            ),
                          );
                        },
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
