import 'package:flutter/foundation.dart';
import '../models/Order.dart';
import '../models/Cart.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _order = [];

  List<Order> get orders => [..._order];

  void addOrder(List<Cart> cartProduct, double total) {
    _order.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        product: cartProduct,
      ),
    );
    notifyListeners();
  }
}
