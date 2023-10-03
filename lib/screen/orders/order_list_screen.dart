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
  // ignore: constant_identifier_names
  Shipping,
  // ignore: constant_identifier_names
  Done,
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
        CustomTabbarWidget(status: OrderStatus.Shipping.name),
        CustomTabbarWidget(status: OrderStatus.Done.name),
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
      child: Consumer<OrderProvider>(
        builder: (context, value, child) {
          List<Transactions> orders = [];

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
          switch (status) {
            case 'waitingPayment':
              orders = value.waitingPayments;
              break;
            case 'packing':
              orders = value.packings;
            case 'Shipping':
              orders = value.delivering;
              break;
            case 'Done':
              orders = value.completed;
              break;
            case 'cancelled':
              orders = value.cancelled;
              break;
            default:
          }

          if (orders.isEmpty) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: const [
                Center(
                  child:
                      Text("You don't have any order(s). Pull down to retry"),
                ),
              ],
            );
          }

          return ListView.separated(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
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
                                Text(
                                  'Payment Status : ${order.paymentStatus}',
                                  style: const TextStyle(color: Colors.white60),
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
}
