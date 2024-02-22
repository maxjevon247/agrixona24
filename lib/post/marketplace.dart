import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  final CollectionReference _products = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _products.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data!.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return Product(
              id: doc.id,
              name: data['name'],
              description: data['description'],
              price: data['price'],
              imageUrl: data['imageUrl'],
            );
          }).toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product.imageUrl),
                title: Text(product.name),
                subtitle: Text('${product.price}'),
                trailing: const Icon(Icons.favorite_border),
                onTap: () {
                  // Navigate to product details page
                },
              );
            },
          );
        },
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}