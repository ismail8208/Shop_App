import 'package:chop_app/providers/products.dart';
import 'package:chop_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFaves;

   ProductsGrid(this.showFaves);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFaves ? productData.favoritesItem : productData.items;
    return products.isEmpty
        ? const Center(
            child: Text('There id no product'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child:  ProductItem(),
            ),
            itemCount: products.length,
          );
  }
}
