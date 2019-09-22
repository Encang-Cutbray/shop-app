import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/Product.dart';
import '../dummy/dummy_product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = product;

  List<Product> get items => [..._items];

  Future<dynamic> addProduct(Product product) {
    const url = 'https://flutter-shop-app-214.firebaseio.com/product.json';
    final dataBody = json.encode({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite
    });
    return http.post(url, body: dataBody).then((result) {
      Product newProduct = Product(
          id: json.decode(result.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void updateProduct(String id, Product newProduct) {
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
