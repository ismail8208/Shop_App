import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem? order;

  const OrderItem({this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('\$${order!.amount}'),
        subtitle: Text(''),
        children: order!.products
            .map((prod) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prod.title,
                      style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${prod.quntity}x \$${prod.price}',
                      style:
                      const TextStyle(fontSize: 18, color:Colors.grey ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
