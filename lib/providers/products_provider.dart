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

  void updateProduct(String id, Product newProduct) {
    print('[on product provider updateProduct]$id');
    print('[on product provider updateProduct] ${newProduct.title}');
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    _items[productIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Product findById(String id) => _items.firstWhere((prod) => prod.id == id);

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();
}
