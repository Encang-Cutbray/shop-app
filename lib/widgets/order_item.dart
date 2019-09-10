import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../models/Order.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  OrderItem({@required this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Rp. ${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh::mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          _expanded
              ? Container(
                  height: min(widget.order.product.length * 20.0 + 10, 180),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  child: ListView(
                    children: widget.order.product
                        .map(
                          (product) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${product.title}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${product.quantity} pcs x Rp. ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
