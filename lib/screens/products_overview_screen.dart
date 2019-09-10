import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/badge_widget.dart';
import '../widgets/product_grid.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_detail_screen.dart';
import './cart_detail_screen.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  void toCartDetail(BuildContext contex) {
    Navigator.of(contex).pushNamed(
      CartDetailScreen.routeName,
    );
  }

  var _showFavoritesOnly = false;
  void filteredProduct(FilterOptions value) {
    setState(() {
      if (value == FilterOptions.Favorite) {
        _showFavoritesOnly = true;
      } else {
        _showFavoritesOnly = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (_, cart, childConsumer) => BadgeWidget(
              value: cart.countCartItem.toString(),
              color: Colors.redAccent,
              child: childConsumer,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => toCartDetail(context),
            ),
          ),
          PopupMenuButton(
            onSelected: (value) => filteredProduct(value),
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorite'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(showFavorites: _showFavoritesOnly),
    );
  }
}
