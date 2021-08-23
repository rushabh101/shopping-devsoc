import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_devsoc/bloc/firebase_handler.dart';

class ShopCard extends StatefulWidget {
  const ShopCard({Key? key, required this.data}) : super(key: key);
  final Map data;

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {

  @override
  Widget build(BuildContext context) {

    FirebaseHandler handler = new FirebaseHandler();

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cart').where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Card();
        }
        bool inCart = false;
        bool inWishlist = false;

        QuerySnapshot q = snapshot.data as QuerySnapshot;
        List items = q.docs;
        items.forEach((element) {
          if(element.data()['item'] == widget.data['title']) {
            if(element.data()['category'] == 'cart') {
              inCart = true;
            }
            if(element.data()['category'] == 'wishlist') {
              inWishlist = true;
            }
          }
        });

        return Card(
            margin: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/view', arguments: widget.data);
                print(widget.data);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(widget.data['image']),
                      height: 127,
                      width: 127,
                    ),
                    SizedBox(height: 15,),
                    Text(
                      widget.data['title'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '\$${widget.data['price'].toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if(!inCart) {
                              handler.addItem(widget.data['title'], 'cart');

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Added to cart"),
                              ));
                            }
                            else {
                              handler.deleteItem(widget.data['title'], 'cart');

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Removed from Cart"),
                              ));
                            }
                          },
                          icon: Icon(!inCart ? Icons.add : Icons.indeterminate_check_box),
                        ),
                        IconButton(
                          onPressed: () {
                            if(!inWishlist) {
                              handler.addItem(widget.data['title'], 'wishlist');

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Added to Wishlist"),
                              ));
                            }
                            else {
                              handler.deleteItem(widget.data['title'], 'wishlist');

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Removed from Wishlist"),
                              ));
                            }

                          },
                          icon: Icon(!inWishlist ? Icons.bookmark : Icons.bookmarks_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        );

      }
    );
  }
}
