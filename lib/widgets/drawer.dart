import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopDrawer extends StatelessWidget {
  const ShopDrawer ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? username = FirebaseAuth.instance.currentUser!.email;
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Welcome! ${username!}'),
          ),
          ListTile(
            title: Text('Home'),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text('Cart'),
            trailing: Icon(Icons.shopping_cart),
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          ListTile(
            title: Text('Wishlist'),
            trailing: Icon(Icons.bookmark),
            onTap: () {
              Navigator.pushNamed(context, 'wishlist');
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            trailing: Icon(Icons.logout),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Sign out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                    Navigator.pop(context);
                  },
                    child: Text('cancel')
                  ),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
