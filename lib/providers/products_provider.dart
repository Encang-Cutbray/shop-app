import 'package:flutter/foundation.dart';

import '../models/Product.dart';
import '../dummy/dummy_product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = product;

  List<Product> get items {
    return [..._items];
  }

  void addProduct(value) {
    _items.add(value);
    notifyListeners();
  }

  Product findById(String id) => _items.firstWhere(
        (prod) => prod.id == id,
      );

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }
}
