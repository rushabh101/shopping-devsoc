import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatefulWidget {
  const ShopCard({Key? key, required this.data}) : super(key: key);
  final Map data;

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  bool plus = true;


  data() async {
    Map d = {'cart': false, 'wishlist': false};
    FirebaseFirestore.instance.collection('cart')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots().forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        Map t = snapshot.data() as Map;
        // print(t);
        if(t['item'] == widget.data['title']) {
          d['cart'] = true;
        }
      }
    });

    // print('hiii');
    return d;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cart').where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        bool inCart = false;
        bool inWishlist = false;

        QuerySnapshot q = snapshot.data as QuerySnapshot;
        List items = q.docs;
        items.forEach((element) {
          // print(element.data());
          // print(widget.data['title']);
          if(element.data()['item'] == widget.data['title']) {
            if(element.data()['category'] == 'cart') {
              inCart = true;
            }
            if(element.data()['category'] == 'wishlist') {
              inWishlist = true;
            }
          }
        });
        // print(items[1].data());
        // print(inCart);
        return Card(
            margin: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/view', arguments: widget.data);
                print(widget.data);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(widget.data['image']),
                      height: 100,
                      width: 100,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if(!inCart) {
                                    FirebaseFirestore.instance.collection('cart').add({
                                    'email' : FirebaseAuth.instance.currentUser!.email,
                                    'item' : widget.data['title'],
                                    'category' : 'cart',
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Added to cart"),
                                    ));
                                  }
                                  else {
                                    FirebaseFirestore.instance.collection('cart')
                                      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                                      .where('item', isEqualTo: widget.data['title'])
                                      .where('category', isEqualTo: 'cart').get().then((querySnapshot) {
                                        querySnapshot.docs.forEach((element) {
                                          element.reference.delete();
                                        });
                                    });
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
                                    FirebaseFirestore.instance.collection('cart').add({
                                      'email' : FirebaseAuth.instance.currentUser!.email,
                                      'item' : widget.data['title'],
                                      'category' : 'wishlist',
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Added to Wishlist"),
                                    ));
                                  }
                                  else {
                                    FirebaseFirestore.instance.collection('cart')
                                      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                                      .where('item', isEqualTo: widget.data['title'])
                                      .where('category', isEqualTo: 'wishlist').get().then((querySnapshot) {
                                        querySnapshot.docs.forEach((element) {
                                          element.reference.delete();
                                        });
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Removed from Wishlist"),
                                    ));
                                  }

                                },
                                icon: Icon(!inWishlist ? Icons.bookmark : Icons.bookmarks_rounded),
                              ),
                            ],
                          )
                        ],
                      ),
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
