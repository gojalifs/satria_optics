import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/transaction_provider.dart';
import 'package:satria_optik/screen/checkout/select_address_screen.dart';

import 'firebase_options.dart';
import 'model/address.dart';
import 'model/cart.dart';
import 'model/glass_frame.dart';
import 'model/order.dart';
import 'provider/address_provider.dart';
import 'provider/cart_provider.dart';
import 'provider/favorite_provider.dart';
import 'provider/frames_provider.dart';
import 'provider/lens_provider.dart';
import 'provider/product_detail_provider.dart';
import 'provider/user_provider.dart';
import 'screen/auth/forgot_password_screen.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';
import 'screen/cart/cart_screen.dart';
import 'screen/checkout/checkout_screen.dart';
import 'screen/home/home_navigation_controller.dart';
import 'screen/message/conversation_screen.dart';
import 'screen/message/messenger_screen.dart';
import 'screen/orders/order_detail_screen.dart';
import 'screen/product/product_detail/product_detail_screen.dart';
import 'screen/product/product_list_screen.dart';
import 'screen/profile/address/add_address_screen.dart';
import 'screen/profile/address/address_screen.dart';
import 'screen/profile/change_profile_detail.dart';
import 'screen/profile/profile_screen.dart';
import 'screen/promo/promotion_screen.dart';
import 'screen/splash/custom_splash.dart';
import 'utils/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => FrameProvider()),
        ChangeNotifierProvider(create: (context) => LensProvider()),
        ChangeNotifierProvider(create: (context) => FrameDetailProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: CustomTheme.customTheme,
        home: const SplashPage(),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          HomeNavigation.routeName: (context) => const HomeNavigation(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          CartPage.routeName: (context) => const CartPage(),
          ConversationPage.routeName: (context) => const ConversationPage(),
          SplashPage.routeName: (context) => const SplashPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
          NotificationPage.routeName: (context) => const NotificationPage(),
          AddressPage.routeName: (context) => const AddressPage(),
          SelectAddressSPage.routeName: (context) => const SelectAddressSPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == PromotionPage.routeName) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) {
                return PromotionPage(
                  title: args['title'],
                  products: args['products'],
                );
              },
            );
          } else if (settings.name == ProductDetailPage.routeName) {
            final args = settings.arguments as GlassFrame;
            return MaterialPageRoute(
              builder: (context) {
                return ProductDetailPage(glassFrame: args);
              },
            );
          } else if (settings.name == CheckoutPage.routeName) {
            final args = settings.arguments as List<Cart>;
            return MaterialPageRoute(
              builder: (context) {
                return CheckoutPage(products: args);
              },
            );
          } else if (settings.name == ChangeProfileDetailPage.routeName) {
            final args = settings.arguments as List;
            return MaterialPageRoute(
              builder: (context) {
                return ChangeProfileDetailPage(
                  beChanged: args[0] as String,
                  data: args[1] as String,
                );
              },
            );
          } else if (settings.name == ProductListPage.routeName) {
            final args = settings.arguments as List;
            return MaterialPageRoute(
              builder: (context) {
                return ProductListPage(
                  title: args[0],
                  categoryProvider: args[1],
                );
              },
            );
          } else if (settings.name == OrderDetailPage.routeName) {
            final args = settings.arguments as Order;
            return MaterialPageRoute(
              builder: (context) {
                return OrderDetailPage(order: args);
              },
            );
          } else if (settings.name == NewAddressPage.routeName) {
            final args = settings.arguments as Address?;
            return MaterialPageRoute(
              builder: (context) {
                if (args != null) {
                  return NewAddressPage(address: args);
                }
                return const NewAddressPage();
              },
            );
          }

          assert(false, 'Need to implement ${settings.name} on routes');
          return null;
        },
      ),
    );
  }
}
