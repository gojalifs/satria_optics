import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../model/transactions.dart';
import '../../provider/order_provider.dart';
import 'order_detail_screen.dart';

class Orderspage extends StatelessWidget {
  const Orderspage({super.key});

  // static List<GlassFrame> products = [
  //   GlassFrame(
  //     imageUrl: [
  //       "https://assets.glasses.com/is/image/Glasses/805289291015__002.png?impolicy=GL_g-thumbnail-plp"
  //     ],
  //     name: 'Prescription Glass',
  //     price: 250000,
  //     rating: '4',
  //     colors: {
  //       'red': '',
  //       'white': '',
  //     },
  //     description: 'awebewiubewubewu',
  //   ),
  //   GlassFrame(
  //     imageUrl: [
  //       "https://cdn.shopify.com/s/files/1/0109/5012/products/RORY_CrystalSlate_52_TQ-1600x1200_8abec855-5208-492b-9217-ee89dd983500.jpg?v=1684520565"
  //     ],
  //     name: 'Sun Glass',
  //     price: 350000,
  //     rating: '4.5',
  //     colors: {
  //       'red': '',
  //       'white': '',
  //     },
  //     description: 'awebewiubewubewu',
  //   ),
  // ];

  // static List<Order> orders = [
  //   Order(
  //     id: 1,
  //     number: '23050001',
  //     address: 'address',
  //     time: '18.00',
  //     status: 'On The Way',
  //     grandTotal: products[0].price! * 1,
  //     paymentMethod: 'shopeepay',
  //     receiptNumber: 'JP294728293',
  //     orderDetail: OrderDetail(
  //       product: products[0],
  //       qty: 1,
  //       price: products[0].price!,
  //       subTotal: products[0].price! * 1,
  //     ),
  //   ),
  //   Order(
  //     id: 2,
  //     number: '23050043',
  //     address: 'address',
  //     time: '18.00',
  //     status: 'Preparing',
  //     paymentMethod: 'ovo',
  //     grandTotal: products[0].price! * 1,
  //     orderDetail: OrderDetail(
  //       product: products[1],
  //       qty: 1,
  //       price: products[1].price!,
  //       subTotal: products[1].price! * 1,
  //     ),
  //   ),
  //   Order(
  //     id: 4,
  //     number: '23050012',
  //     address: 'address',
  //     time: '18.00',
  //     status: 'Delivered',
  //     paymentMethod: 'gopay',
  //     grandTotal: products[0].price! * 1,
  //     orderDetail: OrderDetail(
  //       product: products[0],
  //       qty: 1,
  //       price: products[0].price!,
  //       subTotal: products[0].price! * 1,
  //     ),
  //   ),
  // ];
  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: () async {
        await Provider.of<OrderProvider>(context, listen: false).getOrders();
      },
      refreshOnStart: true,
      child: Consumer<OrderProvider>(
        builder: (context, value, child) {
          if (value.state == ConnectionState.active) {
            return LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 25,
            );
          }
          if (value.orders == null || value.orders!.isEmpty) {
            return ListView(
              children: const [
                Center(
                  child: Text("You don't have any order(s)"),
                ),
              ],
            );
          }
          return ListView.separated(
            itemCount: value.orders?.length ?? 0,
            itemBuilder: (context, index) {
              var order = value.orders![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<OrderProvider>(
                  builder: (context, value, child) => InkWell(
                    onTap: () {
                      value.order = order;
                      Navigator.of(context).pushNamed(
                        OrderDetailPage.routeName,
                        arguments: order,
                      );
                    },
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.network(
                                order.cartProduct![0].product
                                    .colors![order.cartProduct![0].color],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'Error getting images',
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Order #${order.id?.substring(0, 4)}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Payment Status : ${order.paymentStatus}',
                                        style: const TextStyle(
                                            color: Colors.white60),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        value.order = order;
                                        await getPaymentStatus(context, order);
                                      },
                                      icon: const Icon(Icons.refresh_rounded),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Delivery Status : ${order.deliveryStatus}',
                                  style: const TextStyle(color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }

  Future getPaymentStatus(BuildContext context, Transactions transact) async {
    String paymentStatus = 'Expired';

    if (context.mounted) {
      var status = await Provider.of<OrderProvider>(context, listen: false)
          .getPaymentStatus('${transact.id}');

      var transactStatus = status['transaction_status'];
      if (transactStatus == 'settlement' || transactStatus == 'capture') {
        paymentStatus = 'Paid';
      } else if (transactStatus == 'pending' ||
          status['status_code'] == '404') {
        paymentStatus = 'Pending, Tap To Pay Now';
      } else if (transactStatus == 'expire') {
        paymentStatus = 'Payment code has been expired';
      } else if (transactStatus == 'cancel') {
        paymentStatus = 'Order has been cancelled';
      } else if (transactStatus == 'deny') {
        // return 'Your payment has been rejected by the payment provider. message : ${status['status_message']}';
        paymentStatus = 'Deny';
      } else {
        paymentStatus = status['status_message'];
      }
      if (context.mounted) {
        await Provider.of<OrderProvider>(context, listen: false)
            .updatePaymentStatus(transact.id!, paymentStatus);
      }
    }
  }
}
