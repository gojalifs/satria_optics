import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../provider/order_provider.dart';
import '../home/home_navigation_controller.dart';

class PaymentWebView extends StatelessWidget {
  static String routeName = '/paymentWebview';
  final String url;
  final String id;
  const PaymentWebView({
    Key? key,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 25,
            );
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onUrlChange: (change) async {
            var provider = Provider.of<OrderProvider>(context, listen: false);
            if (change.url!.contains('407')) {
              await provider.getPaymentStatus(id);
              await provider.updatePaymentStatus(id, 'Expired');
            }
            /* Diganti masing masing merchant dengan finish deeplink */
            else if (change.url!.contains('deeplink')) {
              await provider.getPaymentStatus(id);
              await provider.updatePaymentStatus(id, 'Pending');
            } else if (change.url!.contains('success') ||
                change.url!.contains('status_code=200')) {
              await provider.getPaymentStatus(id);
              await provider.updatePaymentStatus(id, 'Paid');
              await provider.updateDeliveryStatus(id, 'Packing Your Package');

              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeNavigation.routeName,
                  (route) => false,
                  arguments: 3,
                );
              }
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(url),
      );
    return WillPopScope(
      onWillPop: () {
        controller.goBack();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Proceed Payment'),
          actions: [
            IconButton(
              onPressed: () {
                controller.reload();
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeNavigation.routeName,
                  (route) => false,
                  arguments: 3,
                );
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        body: EasyRefresh(
          onRefresh: () {
            controller.reload();
          },
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
