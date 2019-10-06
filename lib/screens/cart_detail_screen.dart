import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/cart_item.dart';

class CartDetailScreen extends StatelessWidget {
  static const routeName = '/cart';

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
                  ButtonOrder(cart: cart)
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

class ButtonOrder extends StatefulWidget {
  const ButtonOrder({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _ButtonOrderState createState() => _ButtonOrderState();
}

class _ButtonOrderState extends State<ButtonOrder> {
  var _isLoading = false;

  _setLoading(bool param) {
    setState(() {
      _isLoading = param;
    });
  }

  Widget showErrorDialog(BuildContext ctx, String errorMessage) {
    return AlertDialog(
      title: Text('An Error occurred !'),
      content: Text(errorMessage),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              (widget.cart.totalAmount <= 0) ? 'Shop Now' : 'Order Now',
              style: TextStyle(color: Colors.purple),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              _setLoading(true);
              try {
                await Provider.of<OrdersProvider>(context, listen: false)
                    .addOrder(
                  widget.cart.cartItem.values.toList(),
                  widget.cart.totalAmount,
                );
                _setLoading(false);
                widget.cart.clear();
              } catch (error) {
                await showDialog(
                  context: context,
                  builder: (ctx) => showErrorDialog(
                    ctx,
                    error.toString(),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
    );
  }
}
