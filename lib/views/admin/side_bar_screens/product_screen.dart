import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static const String routeName = '/ProductScreen';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<String>> _categoriesFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategoriesFromFirestore();
  }

  Future<List<String>> fetchCategoriesFromFirestore() async {
    final QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection('Categories').get();

    return categorySnapshot.docs
        .map((doc) => doc['catName'] as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Screen'),
      ),
      body: FutureBuilder<List<String>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur de chargement des catégories'),
            );
          } else {
            final categories = snapshot.data ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage Products',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildCategoryDropdown(categories),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildCategoryDropdown(List<String> categories) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      items: categories
          .map((categoryName) => DropdownMenuItem(
                value: categoryName,
                child: Text(categoryName),
              ))
          .toList(),
      onChanged: (selectedCategory) {
        setState(() {
          _selectedCategory = selectedCategory;
        });
        // Vous pouvez ajouter d'autres logiques ici en fonction de la catégorie sélectionnée.
      },
    );
  }
}
