import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/HttpException.dart';
import '../models/Product.dart';
import '../endpoint/endpoint_dev.dart';

class ProductsProvider with ChangeNotifier {
  ProductsProvider(this.authToken);

  final String authToken;

  List<Product> _items = [];

  List<Product> get items => [..._items];

  Future<void> fetchAndSetProduct() async {
    try {
      _items = [];
      final fetchProduct = await http.get(EndpointDev.products(authToken));
      final setProduct = json.decode(fetchProduct.body) as Map<String, dynamic>;

      if(setProduct == null){
        _items = [];
         notifyListeners();
         return;
      }

      setProduct.forEach((indexProduct, productData) {
        _items.add(
          Product(
            id: indexProduct,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> addProduct(Product product) async {
    try {
      final dataBody = json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite
      });

      final response =
          await http.post(EndpointDev.products(authToken), body: dataBody);

      Product newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);

    final bodyProduct = json.encode({
      'title': newProduct.title,
      'price': newProduct.price,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
    });

    await http.patch(EndpointDev.updateOrDeleteProduct(id, authToken), body: bodyProduct);

    _items[productIndex] = newProduct;

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final existingIndexProduct =
        _items.indexWhere((product) => product.id == id);

    var existingProduct = _items[existingIndexProduct];

    _items.removeAt(existingIndexProduct);

    notifyListeners();

    final response = await http.delete(EndpointDev.updateOrDeleteProduct(id, authToken));

    if (response.statusCode >= 400) {
      _items.insert(existingIndexProduct, existingProduct);
      notifyListeners();
      throw HttpException('Opss Someting error, Could not delete product');
    }

    existingProduct = null;
  }

  Product findById(String id) => _items.firstWhere((prod) => prod.id == id);

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();
}
