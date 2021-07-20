import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'shop_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Shopping App for devsoc'),
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

  // late Map t;
  // late List t;


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
      builder: (BuildContext context, AsyncSnapshot snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  Center(child: Text('Please wait its loading...'));
        }else{
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Text('Shopping Devsoc'),
                centerTitle: true,
                backgroundColor: Colors.redAccent,
              ),
              body: ListView(
                children: snapshot.data.map((a) => ShopCard(imgUrl: a['image'], title: a['title'], price: a['price'].toString())).toList().cast<Widget>(),
              ),
            );  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
    // return Scaffold(
    //   backgroundColor: Colors.grey[200],
    //   appBar: AppBar(
    //     title: Text('Shopping Devsoc'),
    //     centerTitle: true,
    //     backgroundColor: Colors.redAccent,
    //   ),
    //   body: Column(
    //     children: t.map((t) => ShopCard(imgUrl: t['image'], title: t['title'], price: t['price'],)).toList(),
    //   ),
    // );
  }
}
