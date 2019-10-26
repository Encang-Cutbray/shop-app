import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
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
  static const routeName = '/product-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Note Won't work
    // Provider.of<ProductsProvider>(context).fetchAndSetProduct();

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<ProductsProvider>(context).fetchAndSetProduct();
    // });

    super.initState();
  }

  Widget showErrorDialog(BuildContext ctx, String errorMessage) {
    return AlertDialog(
      title: Text('An Error occurred !'),
      content: Text(errorMessage),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ],
    );
  }

  void _setInit(bool param) {
    setState(() {
      _isInit = param;
    });
  }

  void _setLoading(bool param) {
    setState(() {
      _isLoading = param;
    });
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _setLoading(true);
      try {
        await Provider.of<ProductsProvider>(context)
            .fetchAndSetProduct()
            .then((_) => _setLoading(false));
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => showErrorDialog(ctx, error.toString()),
        );
      }
    }
    _setInit(false);
    super.didChangeDependencies();
  }

  void toCartDetail(BuildContext contex) {
    Navigator.of(contex).pushNamed(
      CartDetailScreen.routeName,
    );
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavorites: _showFavoritesOnly),
    );
  }
}
