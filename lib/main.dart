import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_devsoc/bloc/search_builder.dart';
import 'package:shopping_devsoc/pages/signin.dart';

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
      routes: {
        '/': (context) => Signin(),
        '/home': (context) => SearchBuilder(),
      }
    );
  }
}