import 'package:flutter/material.dart';

class PaymentPendingPage extends StatelessWidget {
  static String routeName = '/paymentPending';
  const PaymentPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Pending')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Click here to see your orders'),
        ),
      ),
    );
  }
}
