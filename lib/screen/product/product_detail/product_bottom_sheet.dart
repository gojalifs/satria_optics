import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/model/cart.dart';
import 'package:satria_optik/provider/cart_provider.dart';
import 'package:satria_optik/provider/product_detail_provider.dart';
import 'package:satria_optik/utils/custom_function.dart';

import '../../../../model/glass_frame.dart';
import '../../../../model/lens.dart';
import '../../../../provider/lens_provider.dart';
import 'eye_condition_widget.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  final GlassFrame frame;
  final List<String> colorName;
  final String page;
  final String? color;
  final Cart? cart;
  final Lens? lensType;
  final bool? isMinus;
  final MinusData? minusData;

  ProductDetailBottomSheet({
    Key? key,
    required this.frame,
    required this.colorName,
    required this.page,
    this.color,
    this.cart,
    this.lensType,
    this.isMinus,
    this.minusData,
  }) : super(key: key);

  final TextEditingController leftController = TextEditingController();
  final TextEditingController rightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eyeCondition = {};
    List<double> eyes = List.generate(50, (index) => 0.25 * index);
    for (var eye in eyes) {
      eyeCondition['$eye'] = 50000 * eye;
    }

    String? selectedColor;
    double totalPrice = frame.price?.toDouble() ?? 0;
    double leftAdditionalPrice =
        eyeCondition['${minusData?.leftEyeMinus}'] ?? 0;
    double rightAdditionalPrice =
        eyeCondition['${minusData?.rightEyeMinus}'] ?? 0;
    double leftAdditionalPriceP =
        eyeCondition['${minusData?.leftEyePlus}'] ?? 0;
    double rightAdditionalPriceP =
        eyeCondition['${minusData?.rightEyePlus}'] ?? 0;
    bool nearsightedValue = false;
    if (isMinus != null && isMinus!) {
      nearsightedValue = true;

      selectedColor = color;
    }

    String leftMinus = '';
    String rightMinus = '';
    String leftPlus = '';
    String rightPlus = '';

    Lens lensType = Lens();
    GlassFrame frameType = frame;
    if (cart != null) {
      totalPrice = cart!.totalPrice!;
      lensType = cart!.lens;
      frameType = cart!.product;
      selectedColor = cart!.color;
    }
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Stack(
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Input Detail',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                if (page == 'cart')
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  'Are you sure you want to delete it?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    await Provider.of<
                                                                CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFromCart(cart!)
                                                        .whenComplete(() {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Color.fromRGBO(251, 18, 16, 1),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.delete_forever_rounded,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text('Please select the Color'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField(
                                    value: page == 'cart' ? color : null,
                                    validator: (value) {
                                      return value == null
                                          ? 'field required'
                                          : null;
                                    },
                                    items: colorName.map(
                                      (e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      selectedColor = value;

                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Please select the Lens Type',
                                        ),
                                      ),
                                      Tooltip(
                                        triggerMode: TooltipTriggerMode.tap,
                                        message:
                                            'You can see the lens type in description',
                                        child: Icon(Icons.help_outline_rounded),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Consumer<LensProvider>(
                                    builder: (context, lenses, child) {
                                      var lens = lenses.lens;
                                      return DropdownButtonFormField(
                                        value: page == 'cart'
                                            ? this.lensType
                                            : null,
                                        validator: (value) {
                                          return value == null
                                              ? 'field required'
                                              : null;
                                        },
                                        items: lens
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                onTap: () {
                                                  totalPrice =
                                                      (frame.price! + e.price!)
                                                          .toDouble();
                                                },
                                                child: Text(
                                                  '${e.name} +IDR${Format.formatToRupiah(e.price)}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          lensType = value as Lens;
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Are you minus/plus/etc?'),
                                Checkbox(
                                    value: nearsightedValue,
                                    onChanged: (_) {
                                      nearsightedValue = !nearsightedValue;
                                      if (!nearsightedValue) {
                                        totalPrice = frame.price!.toDouble() +
                                            lensType.price!.toDouble();
                                      }
                                      setState(() {});
                                    }),
                              ],
                            ),
                            const SizedBox(height: 20),
                            nearsightedValue
                                ? EyeCondition(
                                    nearsightedValue: nearsightedValue,
                                    minusData: minusData,
                                    onChangedLeft: (p0) {
                                      leftMinus = p0.toString();

                                      totalPrice -= leftAdditionalPrice;
                                      leftAdditionalPrice = eyeCondition['$p0'];
                                      totalPrice += leftAdditionalPrice;
                                      setState(() {});
                                    },
                                    onChangedRight: (p0) {
                                      rightMinus = p0.toString();

                                      totalPrice -= rightAdditionalPrice;
                                      rightAdditionalPrice =
                                          eyeCondition['$p0'];
                                      totalPrice += rightAdditionalPrice;
                                      setState(() {});
                                    },
                                    onChangedLeftP: (p0) {
                                      leftPlus = p0.toString();

                                      totalPrice -= leftAdditionalPriceP;
                                      leftAdditionalPriceP =
                                          eyeCondition['$p0'];
                                      totalPrice += leftAdditionalPriceP;
                                      setState(() {});
                                    },
                                    onChangedRightP: (p0) {
                                      rightPlus = p0.toString();

                                      totalPrice -= rightAdditionalPriceP;
                                      rightAdditionalPriceP =
                                          eyeCondition['$p0'];
                                      totalPrice += rightAdditionalPriceP;

                                      setState(() {});
                                    },
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 20,
                              child: Divider(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Price',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Format.formatToRupiah(totalPrice.toInt()),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Consumer2<FrameDetailProvider, CartProvider>(
                                  builder:
                                      (context, frameProv, cartProv, child) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.reset();

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return LoadingAnimationWidget
                                                  .threeArchedCircle(
                                                      color: Colors.white,
                                                      size: 25);
                                            },
                                          );

                                          var newCartProduct = Cart(
                                              id: cart?.id,
                                              product: frameType,
                                              lens: lensType,
                                              color: selectedColor ?? '',
                                              minusData: MinusData(
                                                leftEyeMinus: leftMinus,
                                                rightEyeMinus: rightMinus,
                                                leftEyePlus: leftPlus,
                                                rightEyePlus: rightPlus,
                                                recipePath: frameProv.imagePath,
                                              ),
                                              totalPrice: totalPrice);
                                          await cartProv
                                              .addToCart(
                                                newCartProduct,
                                                File(frameProv.image?.path ??
                                                    ''),
                                                page == 'cart',
                                              )
                                              .then(
                                                (value) {
                                                  frameProv.removeImage();
                                                  if (page == 'cart') {
                                                    cartProv.getCart(cart!);
                                                  }
                                                  cartProv.carts
                                                      .where((element) {
                                                    if (cart?.id ==
                                                        element.id) {}
                                                    return false;
                                                  });
                                                  return ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text('Added To Cart'),
                                                    ),
                                                  );
                                                },
                                              )
                                              .onError(
                                                (error, stackTrace) =>
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                  SnackBar(
                                                    content: Text('$error'),
                                                  ),
                                                ),
                                              )
                                              .whenComplete(() {
                                                totalPrice =
                                                    frame.price!.toDouble();
                                                nearsightedValue = false;

                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              });
                                        }
                                      },
                                      child: page == 'cart'
                                          ? const Text('Update Cart')
                                          : const Text('Add To Cart'),
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      child: page == 'cart'
          ? const Icon(Icons.edit_rounded)
          : Material(
              elevation: 20,
              color: Colors.transparent,
              borderOnForeground: false,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: const Text(
                  'Add To Cart',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
    );
  }
}
