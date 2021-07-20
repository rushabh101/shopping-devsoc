import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String price;

  const ShopCard({Key? key, required this.imgUrl, required this.title, required this.price}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [Image.network(imgUrl), Text(title), Text(price)],
      )
    );
  }
}
