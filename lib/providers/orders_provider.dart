import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/models/HttpExcemption.dart';
import 'dart:convert';

import '../models/Order.dart';
import '../models/Cart.dart';

class OrdersProvider with ChangeNotifier {
  final orderUrl = 'https://flutter-shop-app-214.firebaseio.com/order.json';
  List<Order> _order = [];

  List<Order> get orders => [..._order].reversed.toList();

  void handleNullOrder() {
    return;
  }

  Future<void> fetchAndSetOrder() async {
    _order = [];
    final response = await http.get(orderUrl);
    final fetchOrder = json.decode(response.body);
    if (fetchOrder == null) {
      handleNullOrder();
    } else {
      final setOrder = json.decode(response.body) as Map<String, dynamic>;

      setOrder.forEach((orderIds, orderData) {
        _order.add(
          Order(
            id: orderIds,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            product: (orderData['product'] as List<dynamic>)
                .map(
                  (cart) => Cart(
                    id: cart['id'],
                    title: cart['title'],
                    quantity: cart['quatity'],
                    price: cart['price'],
                  ),
                )
                .toList(),
          ),
        );
      });
      notifyListeners();
    }
  }

  Future<void> addOrder(List<Cart> cartProduct, double total) async {
    try {
      final timestamps = DateTime.now();
      final bodyOrder = json.encode({
        'amount': total,
        'dateTime': timestamps.toIso8601String(),
        'product': cartProduct
            .map((cartOrder) => {
                  'id': cartOrder.id,
                  'title': cartOrder.title,
                  'quatity': cartOrder.quantity,
                  'price': cartOrder.price
                })
            .toList()
      });
      final response = await http.post(orderUrl, body: bodyOrder);
      _order.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          product: cartProduct,
        ),
      );
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw HttpException('Opss Sometings wrong, Could not process your order');
    }
  }
}
