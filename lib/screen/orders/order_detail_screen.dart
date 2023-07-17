import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/utils/custom_function.dart';

import '../../helper/midtrans_helper.dart';
import '../../provider/order_provider.dart';
import '../../provider/transaction_provider.dart';
import '../payment/payment_webview.dart';

class OrderDetailPage extends StatelessWidget {
  static String routeName = '/order-detail';

  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = Format();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Order Detail'),
        ),
        body: Stack(
          children: [
            Consumer<OrderProvider>(
              builder: (context, value, child) {
                var order = value.order;
                return EasyRefresh(
                  onRefresh: () async {
                    value.getOrder(order.id!);
                  },
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${order.address?.receiverName}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${order.address?.phone}',
                              style: const TextStyle(color: Colors.white54),
                            ),
                            Text(
                              '${order.address?.street} ${order.address?.village}',
                              style: const TextStyle(color: Colors.white54),
                            ),
                            Text(
                              '${order.address?.detail}',
                              style: const TextStyle(color: Colors.white54),
                            ),
                            Text(
                              '${order.address?.subdistrict} ${order.address?.city}',
                              style: const TextStyle(color: Colors.white54),
                            ),
                            Text(
                              '${order.address?.province} ${order.address?.postalCode}',
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
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
                                  order.cartProduct?[0].product
                                      .colors?[order.cartProduct?[0].color],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text(
                                      'Error getting images',
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ),
                              Text(
                                order.cartProduct![0].product.name!,
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: order.cartProduct?.length ?? 0,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const _DetailRow(
                                    title: 'Quantity', detail: '1 Pcs'),
                                _DetailRow(
                                  title: 'Price',
                                  detail:
                                      formatter.formatToRupiah(order.subTotal!),
                                ),
                                _DetailRow(
                                  title: 'Delivery Fee',
                                  detail: formatter
                                      .formatToRupiah(order.shippingFee!),
                                ),
                                _DetailRow(
                                  title: 'Grand Total',
                                  detail:
                                      formatter.formatToRupiah(order.total!),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              _DetailRow(title: 'Order ID', detail: order.id!),
                              _DetailRow(
                                  title: 'Delivery Status',
                                  detail: order.deliveryStatus!),
                              _DetailRow(
                                  title: 'Shipper', detail: order.shipper!),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Receipt Number'),
                                        SelectableText(
                                          order.receiptNumber ??
                                              'Receipt Not Updated Yet',
                                          style: const TextStyle(
                                              color: Colors.white60),
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
                      InkWell(
                        onTap: () async {
                          await value.getOrder(order.id!);
                          await value.getPaymentStatus(order.id!);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                _DetailRow(
                                    title: 'Order Made At',
                                    detail: order.orderMadeTime != null
                                        ? formatter
                                            .timeFormat(order.orderMadeTime!)
                                        : 'No Data'),
                                order.paymentMadeTime != null
                                    ? _DetailRow(
                                        title: 'Paid At',
                                        detail: formatter
                                            .timeFormat(order.paymentMadeTime!))
                                    : _DetailRow(
                                        title: 'Payment Expiry At',
                                        detail: order.paymentExpiry != null
                                            ? formatter.timeFormat(
                                                order.paymentExpiry!)
                                            : formatter.timeFormat(
                                                Timestamp.fromDate(
                                                  order.orderMadeTime!
                                                      .toDate()
                                                      .add(
                                                        const Duration(days: 1),
                                                      ),
                                                ),
                                              ),
                                      ),
                                _DetailRow(
                                    title: 'Order Finish At',
                                    detail: order.orderFinishTime?.toString() ??
                                        'Not Yet Finished'),
                                const Text(
                                  'Tap This Card To Refresh Payment Information',
                                  style: TextStyle(
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (order.paymentStatus == null ||
                          (order.paymentStatus != 'Paid' &&
                              !order.paymentStatus!.contains('expired')))
                        isExpired(order.paymentExpiry!)
                            ? const SizedBox()
                            : ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return LoadingAnimationWidget
                                          .threeArchedCircle(
                                              color: Colors.white, size: 25);
                                    },
                                  );

                                  try {
                                    if (order.redirectUrl == null) {
                                      var transactData = await MidtransHelper()
                                          .getTransactToken(
                                              order.id!, order.total!);
                                      order.copyWith(
                                          redirectUrl:
                                              transactData['redirect_url']);
                                      print(
                                          '1 ${transactData['redirect_url']}');
                                    }
                                    if (context.mounted) {
                                      print('2');
                                      print(order.redirectUrl);
                                      await Provider.of<TransactionProvider>(
                                              context,
                                              listen: false)
                                          .updatePaymentData(order.id!,
                                              order.id!, order.redirectUrl!);
                                      print('4');
                                    }
                                    if (context.mounted) {
                                      Navigator.of(context).pushNamed(
                                        PaymentWebView.routeName,
                                        arguments: {
                                          'url': order.redirectUrl,
                                          'id': order.id,
                                        },
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error, $e')),
                                    );
                                  }
                                },
                                child: const Text('Pay Now'),
                              ),
                      if (order.paymentStatus != null &&
                          order.paymentStatus!.contains('expired'))
                        const Text(
                            'Your Order Has Been Expired, Please Make New Order'),
                      const SizedBox(height: 60),
                    ],
                  ),
                );
              },
            ),
            Padding(
              key: key,
              padding: const EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Consumer<OrderProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: value.order.receiptNumber!.contains('Not')
                        ? null
                        : () {},
                    child: const Text('TRACK YOUR ORDER'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isExpired(Timestamp expiry) {
    var status = DateTime.now().compareTo(expiry.toDate());
    print(expiry.toDate());
    return status >= 0 ? true : false;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            detail,
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
