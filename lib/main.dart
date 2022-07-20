import 'package:chop_app/providers/auth.dart';
import 'package:chop_app/providers/cart.dart';
import 'package:chop_app/providers/orders.dart';
import 'package:chop_app/providers/products.dart';
import 'package:chop_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //test connect
 /* final url = 'https://shop-2ca48-default-rtdb.firebaseio.com/pro.json';
  http.Response res = await http.post(Uri.parse(url),
        body: json.encode({
          "title": 'title',
          "description": 'description',
          "price": 'price',
          "imageUrl": 'imageUrl'
        }));*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousOrders) => previousOrders!
            ..getData(
              authValue.token??"",
              authValue.userId??"",
              previousOrders.orders,
              //previousProducts == null ? null : previousProducts.items,
            ),
        ),        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProducts) => previousProducts!
            ..getData(
              authValue.token??"",
              authValue.userId??"",
              previousProducts.items,
              //  previousProducts == null ? null : previousProducts.items,
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
           // home: ProductOverviewScreen(),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ?  SplashScreen()
                          :  AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrdersScreen.routeName: (_) => const OrdersScreen(),
            EditProductScreen.routeName: (_) => const EditProductScreen(),
            UserProductsScreen.routeName: (_) => const UserProductsScreen()
          },
        ),
      ),
    );
  }
}
