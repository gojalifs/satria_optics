import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/address_provider.dart';
import '../../../utils/common_widget.dart';
import 'add_address_screen.dart';

class AddressPage extends StatelessWidget {
  static String routeName = '/address';
  final bool? isCheckout;
  const AddressPage({
    Key? key,
    this.isCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Address'),
      ),
      body: EasyRefresh(
        onRefresh: () {
          Provider.of<AddressProvider>(context, listen: false).getAddresses();
        },
        refreshOnStart: true,
        child: Stack(
          children: [
            Consumer<AddressProvider>(
              builder: (context, value, child) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  primary: false,
                  itemCount: value.address?.length ?? 0,
                  itemBuilder: (context, index) {
                    var address = value.address?[index];
                    return InkWell(
                      onTap: () {
                        if (isCheckout != null && isCheckout!) {
                          value.setActiveAddress(index);
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushNamed(
                            NewAddressPage.routeName,
                            arguments: address,
                          );
                        }
                      },
                      child: AddressCard(address: address),
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(NewAddressPage.routeName);
                  },
                  child: const Text('Add New Address'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
