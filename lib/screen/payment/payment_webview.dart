import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:satria_optik/screen/payment/payment_pending_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../home/home_navigation_controller.dart';
import 'payment_success_screen.dart';

class PaymentWebView extends StatelessWidget {
  static String routeName = '/paymentWebview';
  final Map<String, dynamic> transactToken;
  const PaymentWebView({
    Key? key,
    required this.transactToken,
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
          onUrlChange: (change) {
            if (change.url!.contains('success')) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                PaymentSuccessPage.routeName,
                (route) => route.settings.name == HomeNavigation.routeName,
              );
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          transactToken['redirect_url'],
        ),
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
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    PaymentPendingPage.routeName,
                    (route) => route.settings.name == HomeNavigation.routeName,
                  );
                },
                icon: const Icon(Icons.close_rounded))
          ],
        ),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
