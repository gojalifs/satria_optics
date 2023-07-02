import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/model/address.dart';

import '../../../provider/address_provider.dart';
import 'add_address_screen.dart';

class AddressPage extends StatelessWidget {
  static String routeName = '/address';
  const AddressPage({super.key});

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
        child: ListView(
          children: [
            Consumer<AddressProvider>(
              builder: (context, value, child) {
                return ListView.builder(
                  primary: false,
                  itemCount: value.address?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var address = value.address?[index];
                    return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            NewAddressPage.routeName,
                            arguments: address,
                          );
                        },
                        child: _AddressCard(address: address));
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NewAddressPage.routeName);
              },
              child: const Text('Add New Address'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    super.key,
    required this.address,
  });

  final Address? address;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address!.receiverName,
              style: const TextStyle(
                fontSize: 21,
              ),
            ),
            const Divider(),
            Text(
              address!.phone,
              style: const TextStyle(color: Colors.white60),
            ),
            Text(
              '''${address!.street}, ${address!.village}, '''
              '''${address!.subdistrict}''',
              style: const TextStyle(color: Colors.white60),
            ),
            Text(
              '${address!.city}, ${address!.province} ${address!.postalCode}',
              style: const TextStyle(color: Colors.white60),
            )
          ],
        ),
      ),
    );
  }
}
