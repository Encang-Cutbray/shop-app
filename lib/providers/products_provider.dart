import 'package:flutter/foundation.dart';

import '../models/Product.dart';
import '../dummy/dummy_product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = product;

  List<Product> get items => [..._items];

  void addProduct(Product product) {
    Product newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) => _items.firstWhere(
        (prod) => prod.id == id,
      );

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();
}
