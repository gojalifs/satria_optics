import 'package:flutter/material.dart';

import '../../model/order.dart';

class OrderDetailPage extends StatelessWidget {
  static String routeName = '/order-detail';
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders #${order.number}'),
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                Card(
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          child: Image.network(
                            order.orderDetail.product.imageUrl![0],
                            errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                'Error getting images',
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                        Text(
                          order.orderDetail.product.name!,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _DetailRow(
                          title: 'Quantity',
                          detail: '${order.orderDetail.qty}',
                        ),
                        _DetailRow(
                          title: 'Price',
                          detail: '${order.orderDetail.price}',
                        ),
                        _DetailRow(
                          title: 'Delivery Fee',
                          detail: '${order.deliveryFee}',
                        ),
                        _DetailRow(
                          title: 'Grand Total',
                          detail: '${order.grandTotal}',
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _DetailRow(
                          title: 'Payment Method',
                          detail: order.paymentMethod,
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Receipt Number'),
                                  Text(
                                    order.receiptNumber ??
                                        'Receipt Not Yet Updated',
                                    style:
                                        const TextStyle(color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Tooltip(
                              message: 'Long press to copy',
                              triggerMode: TooltipTriggerMode.tap,
                              child: Icon(Icons.help),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      _DetailRow(title: 'Order Made', detail: 'timestamp'),
                      _DetailRow(title: 'Payment Made', detail: 'timestamp'),
                      _DetailRow(title: 'Delivery Made', detail: 'timestamp'),
                      _DetailRow(title: 'Order Finished', detail: 'timestamp'),
                    ]),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('TRACK YOUR ORDER'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String detail;

  const _DetailRow({
    Key? key,
    required this.title,
    required this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          detail,
          style: const TextStyle(color: Colors.white60),
        ),
      ],
    );
  }
}
