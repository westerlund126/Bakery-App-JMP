import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/models/category.dart'; // Import your Category model

class CategoryPage extends StatelessWidget {
  final String categoryName;
  const CategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryItem(category: category);
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        // Make the entire card tappable
        onTap: () {
          // Handle category tap here
          // You might want to navigate to a page showing products in this category
          // or pass the category back to the HomePage to filter products
          Navigator.pop(context, category); // Pass the selected category back
        },
        child: Column(
          children: [
            Image.asset(category.imageAssetPath, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(category.name),
            ),
          ],
        ),
      ),
    );
  }
}
