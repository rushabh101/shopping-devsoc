import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping_devsoc/widgets/drawer.dart';
import 'package:shopping_devsoc/widgets/shop_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  test() async {
    print("hi");
    Response r = await get(Uri.parse('https://fakestoreapi.com/products'));
    List t = await jsonDecode(r.body);
    // print(t[0]);
    return t;
  }

  @override
  void initState() {
    super.initState();
    // test();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: test(), // function where you call your api
      builder: (BuildContext context,
          AsyncSnapshot snapshot) { // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
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
                children: snapshot.data.map((a) => ShopCard(data: a))
                    .toList()
                    .cast<Widget>(),
              ),
            ); // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }
}
