import './Cart.dart';
import 'package:flutter/foundation.dart';

class Order {
  final String id;
  final double amount;
  final List<Cart> product;
  final DateTime dateTime;
  
  Order({
    @required this.id,
    @required this.amount,
    @required this.product,
    @required this.dateTime,
  });
}
