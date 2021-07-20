import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'widgets/shop_card.dart';
import 'widgets/drawer.dart';
import 'pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      routes: {
        '/': (context) => Home(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  test() async {
    Response r = await get(Uri.parse('https://fakestoreapi.com/products'));
    List t = await jsonDecode(r.body);
    return t;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: test(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if( snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: Text('Please wait its loading...'));
        }
        else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              backgroundColor: Colors.grey[200],
              drawer: ShopDrawer(),
              appBar: AppBar(
                title: Text(
                  'Shopping Devsoc',
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.white54,
              ),
              body: ListView(
                children: snapshot.data.map((a) => ShopCard(data: a)).toList().cast<Widget>(),
              ),
            );
        }
      },
    );
  }
}
