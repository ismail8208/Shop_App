import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrder();
  }

  // .fetchAndSetProducts(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("your Orders"),
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else/* {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error occurred'),
                );
              } else*/ {
                return RefreshIndicator(
                    onRefresh: () => _refreshProducts(context), //........
                    child: Consumer<Orders>(
                      builder: (ctx, orderData, _) =>
                          ListView.builder(
                              itemCount: orderData.orders.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  OrderItem(order: orderData.orders[index],)),
                    )
                );
              }
          }
          // }herrrrrrrrrrrrrrrrrrrrrrrrrrr
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrder();
  }
  // .fetchAndSetProducts(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("your Orders"),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
            onRefresh: () => _refreshProducts(context),//........
            child:Consumer<Orders>(
              builder: (ctx, orderData, _) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (BuildContext context, int index) =>
                      OrderItem(order: orderData.orders[index],)),
            )
        ),
      ),
    );
  }
}*/
/* FutureBuilder(
        future:
            Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('An error occurred'),
              );
            } else {
             return Consumer<Orders>(
                builder: (ctx, orderData, _) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (BuildContext context, int index) =>
                        OrderItem(order: orderData.orders[index],)),
              );
            }
          }
        },
      ),*/

/*import 'package:chop_app/providers/products.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("your order"),
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (_,AsyncSnapshot snapshot){
        return Center();

      }),
    );
  }
}
*/
