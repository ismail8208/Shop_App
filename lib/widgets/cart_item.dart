import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          margin:const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction){
          return showDialog(context: context, builder: (ctx)=>AlertDialog(title:const Text("Are you sure?") ,
          content: const Text('Do you want ro remove item from the cart?'),
            actions: [
              FlatButton(onPressed: ()=> Navigator.of(context).pop(), child:const Text('No!')),
              FlatButton(onPressed: ()=> Navigator.of(context).pop(true), child:const Text('Yes!'))
            ],
          ));
        },
        onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeItem(productId);
        },
        key: ValueKey(id),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$$price'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text("Total \$${price * quantity}"),
              trailing: Text('$quantity x'),
            ),
          ),
        ));
  }
}
