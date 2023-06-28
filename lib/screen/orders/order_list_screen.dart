import 'package:flutter/material.dart';
import 'package:satria_optik/model/order.dart';
import 'package:satria_optik/screen/orders/order_detail_screen.dart';

import '../../model/glass_frame.dart';

class Orderspage extends StatelessWidget {
  const Orderspage({super.key});

  static List<GlassFrame> products = [
    GlassFrame(
      imageUrl: [
        "https://assets.glasses.com/is/image/Glasses/805289291015__002.png?impolicy=GL_g-thumbnail-plp"
      ],
      name: 'Prescription Glass',
      price: 250000,
      rating: '4',
      colors: {
        'red': '',
        'white': '',
      },
      description: 'awebewiubewubewu',
    ),
    GlassFrame(
      imageUrl: [
        "https://cdn.shopify.com/s/files/1/0109/5012/products/RORY_CrystalSlate_52_TQ-1600x1200_8abec855-5208-492b-9217-ee89dd983500.jpg?v=1684520565"
      ],
      name: 'Sun Glass',
      price: 350000,
      rating: '4.5',
      colors: {
        'red': '',
        'white': '',
      },
      description: 'awebewiubewubewu',
    ),
  ];

  static List<Order> orders = [
    Order(
      id: 1,
      number: '23050001',
      address: 'address',
      time: '18.00',
      status: 'On The Way',
      grandTotal: products[0].price! * 1,
      paymentMethod: 'shopeepay',
      receiptNumber: 'JP294728293',
      orderDetail: OrderDetail(
        product: products[0],
        qty: 1,
        price: products[0].price!,
        subTotal: products[0].price! * 1,
      ),
    ),
    Order(
      id: 2,
      number: '23050043',
      address: 'address',
      time: '18.00',
      status: 'Preparing',
      paymentMethod: 'ovo',
      grandTotal: products[0].price! * 1,
      orderDetail: OrderDetail(
        product: products[1],
        qty: 1,
        price: products[1].price!,
        subTotal: products[1].price! * 1,
      ),
    ),
    Order(
      id: 4,
      number: '23050012',
      address: 'address',
      time: '18.00',
      status: 'Delivered',
      paymentMethod: 'gopay',
      grandTotal: products[0].price! * 1,
      orderDetail: OrderDetail(
        product: products[0],
        qty: 1,
        price: products[0].price!,
        subTotal: products[0].price! * 1,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(OrderDetailPage.routeName, arguments: order);
            },
            child: SizedBox(
              height: 75,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    child: Image.network(
                      order.orderDetail.product.imageUrl![0],
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Error getting images',
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Orders #${order.number}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        'Status : ${order.status}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
