import 'package:flutter/material.dart';

import 'package:satria_optik/screen/cart/cart_screen.dart';
import 'package:satria_optik/screen/orders/order_list_screen.dart';
import 'package:satria_optik/screen/product/product_home_screen.dart';

import '../favorite/favourite_screen.dart';
import '../message/messenger_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class HomeNavigation extends StatefulWidget {
  static const routeName = '/home';
  final int? index;
  const HomeNavigation({
    Key? key,
    this.index,
  }) : super(key: key);

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  List<BottomNavigationBarItem> botNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_rounded),
      label: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.format_align_justify_outlined),
      label: 'All Product',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.view_list_rounded),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_rounded),
      label: 'Account',
    ),
  ];

  int botNavIndex = 0;

  @override
  void initState() {
    botNavIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: appBar(botNavIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: botNavBarItems,
            currentIndex: botNavIndex,
            onTap: (value) {
              setState(() {
                botNavIndex = value;
              });
            },
          ),
          body: botNavIndex == 0
              ? const HomePage()
              : botNavIndex == 1
                  ? const FavouritePage()
                  : botNavIndex == 2
                      ? const ProductPage()
                      : botNavIndex == 3
                          ? const Orderspage()
                          : const ProfilePage(),
        ),
      ),
    );
  }

  AppBar appBar(int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: const Text('Satria Jaya Optik'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NotificationPage.routeName);
              },
              icon: const Icon(Icons.notifications_rounded),
            ),
          ],
        );
      case 1:
        return AppBar(
          title: const Text('Your Favorite'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NotificationPage.routeName);
              },
              icon: const Icon(Icons.notifications_rounded),
            ),
          ],
        );
      case 2:
        return AppBar(
          title: const Text('Satria Optik'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
          ],
        );
      case 3:
        return AppBar(
          title: const Text('Your Orders'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                child: Text('Waiting Payment'),
              ),
              Tab(
                child: Text('Packing'),
              ),
              Tab(
                child: Text('Delivering'),
              ),
              Tab(
                child: Text('Completed'),
              ),
              Tab(
                child: Text('Cancelled'),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
          ],
        );
      default:
        return AppBar(
          title: const Text('Profile'),
        );
    }
  }
}
