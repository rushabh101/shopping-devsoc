import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shopping_devsoc/bloc/search_bloc.dart';
import 'package:shopping_devsoc/widgets/drawer.dart';
import 'package:shopping_devsoc/widgets/shop_card.dart';

class WishlistBuilder extends StatelessWidget {
  const WishlistBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: Wishlist(),
    );
  }
}


class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {

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
                return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('cart').where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email).where('category', isEqualTo: 'wishlist').snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var d = dt;

                      QuerySnapshot q = snapshot.data as QuerySnapshot;
                      List items = q.docs;
                      items = items.map((e) => e.data()['item']).toList();
                      print(items);
                      d = d.where((i) => items.contains(i['title']));

                      return BlocBuilder<SearchCubit, String>(builder: (context, state) {
                        var dtemp = d;
                        if(isSearching) {
                          final match = new RegExp(state.replaceAll(new RegExp(r"\s+"), "").toLowerCase());
                          dtemp = dtemp.where((i) => match.hasMatch(i['title'].replaceAll(new RegExp(r"\s+"), "").toLowerCase())).toList();
                        }
                        return ListView(
                          children: dtemp.map((a) => ShopCard(data: a)).toList().cast<Widget>(),
                        );
                      });
                    }
                );
              }
            }
          },
        )
    );

  }
}
