import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/address_provider.dart';

import '../../utils/common_widget.dart';

class SelectAddressSPage extends StatelessWidget {
  static String routeName = '/selectAddress';
  const SelectAddressSPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AddressProvider>(context, listen: false).address == null) {
      Provider.of<AddressProvider>(context, listen: false).getAddresses();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Address')),
      body: EasyRefresh(
        onRefresh: () {
          Provider.of<AddressProvider>(context, listen: false).getAddresses();
        },
        refreshOnStart: true,
        child: Consumer<AddressProvider>(
          builder: (context, value, child) {
            if (value.state == ConnectionState.active) {
              return LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white,
                size: 25,
              );
            }
            return ListView.builder(
              primary: false,
              itemCount: value.address?.length ?? 0,
              itemBuilder: (context, index) {
                var address = value.address?[index];
                return InkWell(
                  onTap: () {
                    value.setActiveAddress(index);
                    Navigator.of(context).pop();
                  },
                  child: AddressCard(address: address),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
