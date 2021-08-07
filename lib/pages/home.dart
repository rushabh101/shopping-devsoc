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
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.white54,
        ),
        body: FutureBuilder(
          future: test(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Please wait its loading...'));
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
                  return ListView(
                    children: dtemp.map((a) => ShopCard(data: a)).toList().cast<Widget>(),
                  );
                });
              }
            }
          },
        )
    );

  }
}
