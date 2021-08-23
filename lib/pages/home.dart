import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shopping_devsoc/bloc/search_bloc.dart';
import 'package:shopping_devsoc/widgets/drawer.dart';
import 'package:shopping_devsoc/widgets/shop_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  test() async {
    String url = 'https://fakestoreapi.com/products';
    var data = await DefaultCacheManager().getSingleFile(url);
    String thing = await data.readAsString();
    List tt = await jsonDecode(thing);
    return tt;
  }

  @override
  void initState() {
    super.initState();
    // test();
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {

    StreamController<int> filterController = StreamController<int>();
    Stream<int> filter = filterController.stream;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: ShopDrawer(),
        appBar: AppBar(
          title: isSearching ?
          TextField(
            decoration: InputDecoration(
                hintText: "HI"
            ),
            onChanged: (text) => context.read<SearchCubit>().search(text),
          ) :
          Text(
            'Shopping Devsoc',
            style: TextStyle(
                color: Colors.black
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.cancel : Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
            ),
            IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      height: 250,
                      child: Column(
                        children: [
                          Text("Sort By:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextButton(
                            onPressed: () {
                              filterController.add(1);
                              Navigator.pop(context, 'OK');
                            },
                            child: Text("Price: Increasing")
                          ),
                          TextButton(
                              onPressed: () {
                                filterController.add(2);
                                Navigator.pop(context, 'OK');
                              },
                              child: Text("Price: Decreasing")
                          ),
                          TextButton(
                              onPressed: () {
                                filterController.add(3);
                                Navigator.pop(context, 'OK');
                              },
                              child: Text("Name: A to Z")
                          ),
                          TextButton(
                              onPressed: () {
                                filterController.add(4);
                                Navigator.pop(context, 'OK');
                              },
                              child: Text("Name: Z to A")
                          ),
                        ],
                      ),
                    ),
                  )
                );
              },
              icon: Icon(Icons.filter_alt)
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.white54,
        ),
        body: FutureBuilder(
          future: test(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else {
                var dt = snapshot.data;
                return BlocBuilder<SearchCubit, String>(builder: (context, state) {
                  var dtemp = dt;
                  if(isSearching) {
                    final match = new RegExp(state.replaceAll(new RegExp(r"\s+"), "").toLowerCase());
                    dtemp = dtemp.where((i) => match.hasMatch(i['title'].replaceAll(new RegExp(r"\s+"), "").toLowerCase())).toList();
                  }
                  return StreamBuilder<Object>(
                    stream: filter,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        switch(snapshot.data) {
                          case 1:
                            {
                              dtemp.sort((a, b) =>
                                  a['price'].compareTo(b['price']) as int);
                            }
                            break;
                          case 2:
                            {
                              dtemp.sort((a, b) =>
                                  b['price'].compareTo(a['price']) as int);
                            }
                            break;
                          case 3:
                            {
                              dtemp.sort((a, b) =>
                                  a['title'].compareTo(b['title']) as int);
                            }
                            break;
                          case 4:
                            {
                              dtemp.sort((a, b) =>
                                  b['title'].compareTo(a['title']) as int);
                            }
                            break;
                        }
                      }
                      return GridView.count(
                        childAspectRatio: 0.75,
                        crossAxisCount: 2,
                        children: dtemp.map((a) => ShopCard(data: a)).toList().cast<Widget>(),
                      );
                    }
                  );
                });
              }
            }
          },
        )
    );
  }
}
