import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDropdownWidget extends StatefulWidget {
  final void Function(String) onCategorySelected;

  const CategoryDropdownWidget({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  State<CategoryDropdownWidget> createState() => _CategoryDropdownWidgetState();
}

class _CategoryDropdownWidgetState extends State<CategoryDropdownWidget> {
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
    return FutureBuilder<List<String>>(
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
                DropdownButtonFormField<String>(
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
                    widget.onCategorySelected(selectedCategory!);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
