import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/utils/custom_function.dart';

import '../../model/cart.dart';
import '../../provider/cart_provider.dart';
import '../../provider/lens_provider.dart';
import '../checkout/checkout_screen.dart';
import '../product/product_detail/product_bottom_sheet.dart';
import '../product/product_detail/product_detail_screen.dart';

class CartPage extends StatefulWidget {
  static String routeName = '/cart';

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int total = 0;

  List<Cart> checkoutList = [];
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProv, child) => EasyRefresh(
            onRefresh: () {
              Provider.of<LensProvider>(context, listen: false).getLens();
              Provider.of<CartProvider>(context, listen: false).getCarts();
            },
            refreshOnStart: cartProv.carts.isEmpty ? true : false,
            child: Stack(
              children: [
                Builder(
                  builder: (context) {
                    if (cartProv.state == ConnectionState.active) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    if (cartProv.carts.isEmpty) {
                      return ListView(
                        children: const [
                          Center(
                            child: Text('Your cart is empty'),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      itemCount: cartProv.carts.length,
                      itemBuilder: (context, index) {
                        var cart = cartProv.carts[index];

                        int subTotal = cart.totalPrice!.toInt();

                        String formattedSubTotal =
                            Format.formatToRupiah(subTotal);

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
                                  value: checkoutList.contains(cart),
                                  onChanged: (value) {
                                    if (value!) {
                                      checkoutList.add(cart);
                                      total += cart.totalPrice?.toInt() ?? 0;
                                      totalPrice = total;
                                    } else {
                                      checkoutList.remove(cart);
                                      total -= cart.totalPrice?.toInt() ?? 0;
                                      totalPrice = total;
                                    }
                                    !value;
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: 10),
                                Image.network(
                                  cart.product.colors!.isNotEmpty &&
                                          cart.product.colors?[0].url != null
                                      ? cart.product.colors![0].url!
                                      : 'https://firebasestorage.googleapis.com/v0/b/satria-jaya-optik.appspot.com/o/default%2Fbonbon-boy-with-red-hair-and-glasses.png?alt=media&token=53c99253-a46d-4f31-9851-48b6b76b1d54',
                                  width: 75,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_rounded);
                                  },
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cart.product.name ??'',
                                        style: const TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        Format.formatToRupiah(
                                            cart.product.price),
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
                                            cart.lens.name ??'',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          Text(
                                            Format.formatToRupiah(
                                                cart.lens.price),
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
                                          cart.minusData?.leftEyeMinus !=
                                                      null &&
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ProductDetailBottomSheet(
                                    frame: cart.product,
                                    colorName: cart.product.colors!
                                        .map((e) => e.name ?? '')
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
                            child: Text(
                              'Total ${Format.formatToRupiah(totalPrice)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Consumer<CartProvider>(
                          builder: (context, value, child) {
                            return InkWell(
                              onTap: checkoutList.isEmpty
                                  ? null
                                  : () {
                                      Navigator.of(context).pushNamed(
                                        CheckoutPage.routeName,
                                        arguments: checkoutList,
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
      ),
    );
  }
}
