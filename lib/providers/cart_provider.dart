import 'package:flutter/foundation.dart';
import '../models/Cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _cartItem = {};

  Map<String, Cart> get cartItem {
    return {..._cartItem};
  }

  int get countCartItem {
    return _cartItem.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItem.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addCart(String productId, double price, String title) {
    if (_cartItem.containsKey(productId)) {
      _cartItem.update(
        productId,
        (value) => Cart(
          id: DateTime.now().toString(),
          title: value.title,
          price: value.price,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _cartItem.putIfAbsent(
        productId,
        () => Cart(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    print(productId);
    _cartItem.remove(productId);
    notifyListeners();
  }

  void clear() {
    _cartItem.clear();
    notifyListeners();
  }
}
