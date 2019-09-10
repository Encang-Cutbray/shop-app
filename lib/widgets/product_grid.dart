import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;

  ProductGrid({this.showFavorites});
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final product =
        showFavorites ? productData.favoriteItems : productData.items;
    return GridView.builder(
      itemCount: product.length,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
        value: product[index],
        child: ProductItem(),
      ),
    );
  }
}
