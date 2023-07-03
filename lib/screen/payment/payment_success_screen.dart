import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  static String routeName = '/paymentSuccess';
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
    );
  }
}
