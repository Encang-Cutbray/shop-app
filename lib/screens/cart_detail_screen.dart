import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

import '../widgets/cart_item.dart';
import './order_screen.dart';

class CartDetailScreen extends StatelessWidget {
  static const routeName = '/cart';

  void addOrder(BuildContext context, cart) {
    Provider.of<OrdersProvider>(context, listen: false)
        .addOrder(cart.cartItem.values.toList(), cart.totalAmount);
  }

  void clearCart(CartProvider cart) {
    cart.clear();
  }

  void toOrderDetail(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
  }

  void toShop(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\Rp. ${cart.totalAmount.toStringAsFixed(2)}'),
                  ),
                  FlatButton(
                    child: Text(
                      cart.cartItem.values.length == 0
                          ? 'Shoping Now'
                          : 'Order Now',
                      style: TextStyle(color: Colors.purple),
                    ),
                    onPressed: () {
                      if (cart.cartItem.values.length == 0) {
                        toShop(context);
                        return;
                      }
                      addOrder(context, cart);
                      clearCart(cart);
                      toOrderDetail(context);
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) => CartItem(
                id: cart.cartItem.values.toList()[index].id,
                productId: cart.cartItem.keys.toList()[index],
                title: cart.cartItem.values.toList()[index].title,
                quantity: cart.cartItem.values.toList()[index].quantity,
                price: cart.cartItem.values.toList()[index].price,
              ),
              itemCount: cart.cartItem.length,
            ),
          ),
        ],
      ),
    );
  }
}
