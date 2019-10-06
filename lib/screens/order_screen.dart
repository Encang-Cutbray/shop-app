import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  void _setLoading(bool param) {
    setState(() {
      _isLoading = param;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      _setLoading(true);
      await Provider.of<OrdersProvider>(context, listen: false)
          .fetchAndSetOrder();
      _setLoading(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (_, index) =>
                  OrderItem(order: ordersData.orders[index]),
            ),
    );
  }
}
