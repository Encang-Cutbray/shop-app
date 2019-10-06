import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorite(bool param) {
    isFavorite = param;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;

    final urlUpdateFavorite =
        'https://flutter-shop-app-214.firebaseio.com/product/$id.json';
    try {
      _setFavorite(!isFavorite);
      final response = await http.patch(
        urlUpdateFavorite,
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (response.statusCode >= 400) {
        _setFavorite(oldStatus);
      }
    } catch (error) {
      _setFavorite(oldStatus);
      throw error;
    }
  }
}
