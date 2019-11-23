import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth/auth_screen.dart';
import './screens/cart_detail_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/add_product_screen.dart';
import './screens/example_form.dart';

import './providers/auth_provider.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';

import './helpers/custome_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          builder: (ctx, auth, previousProduct) =>
              ProductsProvider(auth.userToken, auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          builder: (ctx, auth, previousOrder) =>
              OrdersProvider(auth.userToken, auth.userId),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.orangeAccent,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomePageTransationRoute(),
                TargetPlatform.iOS: CustomePageTransationRoute()
              },
            ),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : AuthScreen(),
                ),
          routes: {
            AuthScreen.routeName: (_) => AuthScreen(),
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartDetailScreen.routeName: (_) => CartDetailScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            AddProductScreen.routeName: (_) => AddProductScreen(),
            ExampleForm.routeName: (_) => ExampleForm(),
          },
        ),
      ),
    );
  }
}
