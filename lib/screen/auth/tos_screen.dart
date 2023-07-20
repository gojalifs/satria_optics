import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TOSPage extends StatelessWidget {
  static String routeName = '/tosScreen';
  const TOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onUrlChange: (change) async {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(
            'https://gojalifs.github.io/satria-optik-page/privacy_policy.html'),
      );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Term And Privacy Policy'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
