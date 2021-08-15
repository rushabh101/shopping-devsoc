import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHandler {

  deleteItem(String item, String category) {
    FirebaseFirestore.instance.collection('cart')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('item', isEqualTo: item)
        .where('category', isEqualTo: category).get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }
  addItem(String item, String category) {
    FirebaseFirestore.instance.collection('cart').add({
      'email' : FirebaseAuth.instance.currentUser!.email,
      'item' : item,
      'category' : category,
    });
  }
}