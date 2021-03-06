import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_devsoc/bloc/search_builder.dart';
import 'package:shopping_devsoc/pages/cart.dart';
import 'package:shopping_devsoc/pages/item_page.dart';
import 'package:shopping_devsoc/pages/signin.dart';
import 'package:shopping_devsoc/pages/signup.dart';
import 'package:shopping_devsoc/pages/wishlist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/' : '/home',
      routes: {
        '/': (context) => Signin(),
        '/home': (context) => SearchBuilder(),
        '/view': (context) => ItemPage(),
        '/signup': (context) => SignUp(),
        '/cart' : (context) => CartBuilder(),
        'wishlist' : (context) => WishlistBuilder(),
      }
    );
  }
}