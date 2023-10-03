import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/model/cart.dart';
import 'package:satria_optik/utils/custom_function.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/midtrans_helper.dart';
import '../../provider/order_provider.dart';
import '../../provider/transaction_provider.dart';
import '../payment/payment_webview.dart';

class OrderDetailPage extends StatelessWidget {
  static String routeName = '/order-detail';

  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Order Detail'),
        ),
        floatingActionButton: Consumer<OrderProvider>(
          builder: (context, value, child) {
            if (value.order.orderStatus != 'waitingPayment') {
              return FloatingActionButton.extended(
                onPressed: () async {
                  var url = Uri.parse(
                      'https://cekresi.com/?noresi=${value.order.receiptNumber}');
                  if (!await launchUrl(url)) {
                    if (context.mounted) {
                      CherryToast.error(
                        toastPosition: Position.bottom,
                        title: const Text("Couldn't track receipt number"),
                      ).show(context);
                    }
                  }
                },
                label: const Text('TRACK ORDER'),
              );
            } else {
              return const SizedBox();
            }
          },
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
                        child: ListView.separated(
                          padding: const EdgeInsets.all(10),
                          itemCount: order.cartProduct?.length ?? 0,
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const Divider(thickness: 5);
                          },
                          itemBuilder: (context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Image.network(
                                      order.cartProduct![0].product.colors![0]
                                          .url!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Text(
                                          'Error getting images',
                                          textAlign: TextAlign.center,
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                    order.cartProduct![index].product.name!,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Divider()),
                              const _DetailRow(
                                  title: 'Quantity', detail: '1 Pcs'),
                              _DetailRow(
                                  title: 'Lens Type',
                                  detail:
                                      '''${order.cartProduct![index].lens.name!} '''
                                      '''${Format.formatToRupiah(order.cartProduct![index].lens.price!)}'''),
                              MinusDataPanel(
                                minusData: order.cartProduct![index].minusData,
                              ),
                              _DetailRow(
                                title: 'Price',
                                detail: Format.formatToRupiah(
                                    order.cartProduct![index].product.price!),
                              ),
                              _DetailRow(
                                title: 'Total',
                                detail: Format.formatToRupiah(
                                  order.cartProduct![index].totalPrice!.toInt(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _DetailRow(
                                  title: 'Subtotal Product(s)',
                                  detail:
                                      Format.formatToRupiah(order.subTotal!)),
                              _DetailRow(
                                title: 'Delivery Fee',
                                detail:
                                    Format.formatToRupiah(order.shippingFee!),
                              ),
                              _DetailRow(
                                title: 'Discount',
                                detail: Format.formatToRupiah(order.discount!),
                              ),
                              _DetailRow(
                                  title: 'Grand Total',
                                  detail: Format.formatToRupiah(
                                      order.subTotal! +
                                          order.shippingFee! -
                                          order.discount!)),
                            ],
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
                                        ? Format.timeFormat(
                                            order.orderMadeTime!)
                                        : 'No Data'),
                                order.paymentMadeTime != null
                                    ? _DetailRow(
                                        title: 'Paid At',
                                        detail: Format.timeFormat(
                                            order.paymentMadeTime!))
                                    : _DetailRow(
                                        title: 'Payment Expiry At',
                                        detail: order.paymentExpiry != null
                                            ? Format.timeFormat(
                                                order.paymentExpiry!)
                                            : Format.timeFormat(
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
                                  detail:
                                      Format.timeFormat(order.orderFinishTime),
                                ),
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
                      Consumer<OrderProvider>(
                        builder: (context, value, child) => ElevatedButton(
                          onPressed: value.delivering.contains(value.order)
                              ? () {
                                  value.markAsCompleted();
                                }
                              : null,
                          child: value.state == ConnectionState.active
                              ? const CircularProgressIndicator()
                              : const Text('Mark As Finished'),
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
                                    }
                                    if (context.mounted) {
                                      await Provider.of<TransactionProvider>(
                                              context,
                                              listen: false)
                                          .updatePaymentData(order.id!,
                                              order.id!, order.redirectUrl!);
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
          ],
        ),
      ),
    );
  }

  bool isExpired(Timestamp expiry) {
    var status = DateTime.now().compareTo(expiry.toDate());
    return status >= 0 ? true : false;
  }
}

class MinusDataPanel extends StatefulWidget {
  final MinusData? minusData;
  const MinusDataPanel({
    Key? key,
    this.minusData,
  }) : super(key: key);

  @override
  State<MinusDataPanel> createState() => _MinusDataPanelState();
}

class _MinusDataPanelState extends State<MinusDataPanel> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    if (widget.minusData!.leftEyeMinus!.isEmpty) {
      return const SizedBox();
    }
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          this.isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
            canTapOnHeader: true,
            backgroundColor: Colors.transparent,
            isExpanded: isExpanded,
            headerBuilder: (context, isExpanded) {
              return const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Minus Data',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Left Minus'),
                      Text(
                        widget.minusData!.leftEyeMinus!.isEmpty
                            ? '-'
                            : widget.minusData!.leftEyeMinus!,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Right Minus'),
                      Text(
                        widget.minusData!.leftEyeMinus!.isEmpty
                            ? '-'
                            : widget.minusData!.leftEyeMinus!,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Left Plus'),
                      Text(
                        widget.minusData!.leftEyeMinus!.isEmpty
                            ? '-'
                            : widget.minusData!.leftEyeMinus!,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Right Plus'),
                      Text(
                        widget.minusData!.leftEyeMinus!.isEmpty
                            ? '-'
                            : widget.minusData!.leftEyeMinus!,
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
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
