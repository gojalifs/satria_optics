import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../model/transactions.dart';
import '../../provider/order_provider.dart';
import 'order_detail_screen.dart';

enum OrderStatus {
  waitingPayment,
  packing,
  delivering,
  completed,
  cancelled,
}

class Orderspage extends StatelessWidget {
  const Orderspage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        CustomTabbarWidget(status: OrderStatus.waitingPayment.name),
        CustomTabbarWidget(status: OrderStatus.packing.name),
        CustomTabbarWidget(status: OrderStatus.delivering.name),
        CustomTabbarWidget(status: OrderStatus.completed.name),
        CustomTabbarWidget(status: OrderStatus.cancelled.name),
      ],
    );
  }
}

class CustomTabbarWidget extends StatelessWidget {
  final String status;
  const CustomTabbarWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: () async {
        await Provider.of<OrderProvider>(context, listen: false)
            .getOrdersByStatus(status);
      },
      refreshOnStart: true,
      child: Consumer<OrderProvider>(
        builder: (context, value, child) {
          if (value.state == ConnectionState.active) {
            return ListView(
              children: [
                LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.white,
                  size: 25,
                ),
              ],
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
                                order.cartProduct![0].product.colors![0].url!,
                                // order.cartProduct![0].product
                                //     .colors![order.cartProduct![0].color].url!,
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
        paymentStatus = 'Pending';
      } else if (transactStatus == 'expire') {
        paymentStatus = 'Expired';
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
