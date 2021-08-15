import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_devsoc/bloc/firebase_handler.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image(
                width: 160,
                height: 160,
                image: NetworkImage(data['image']),
              ),
            ),
            Divider(
              color: Colors.grey[800],
              height: 60.0,
            ),
            Text(
              '${data['title']}',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '\$${data['price']}',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              '${data['description']}',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('cart').where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
              builder: (context, snapshot) {

                FirebaseHandler handler = new FirebaseHandler();
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
                  if(element.data()['item'] == data['title']) {
                    if(element.data()['category'] == 'cart') {
                      inCart = true;
                    }
                    if(element.data()['category'] == 'wishlist') {
                      inWishlist = true;
                    }
                  }
                });

                return Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        if(!inCart) {
                          handler.addItem(data['title'], 'cart');
                        }
                        else {
                          handler.deleteItem(data['title'], 'cart');
                        }
                      },
                      child: Text(!inCart ? "Add to Cart" : "Remove from Cart")
                    ),
                    TextButton(
                        onPressed: () {
                          if(!inWishlist) {
                            handler.addItem(data['title'], 'wishlist');
                          }
                          else {
                            handler.deleteItem(data['title'], 'wishlist');
                          }
                        },
                        child: Text(!inWishlist ? "Add to Wishlist" : "Remove from Wishlist")
                    ),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}
