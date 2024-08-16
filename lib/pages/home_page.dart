import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/models/category.dart';
import 'package:sertifikasi_jmp/models/product_data.dart';
import 'package:sertifikasi_jmp/pages/category_page.dart';
import 'package:sertifikasi_jmp/widget/product_item.dart';
import 'package:sertifikasi_jmp/widget/support_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == 'All'
        ? products
        : products
            .where((product) => product.category == _selectedCategory)
            .toList();
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Container(
        margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey, There",
                        style: AppWidget.boldTextFieldStyle(),
                      ),
                      Text(
                        "Good Morning",
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _showLogoutConfirmationDialog(context);
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "images/profile.png",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        )),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Products",
                        hintStyle: AppWidget.lightTextFieldStyle(),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                  )),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final selectedCategory = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPage(
                            categoryName: _selectedCategory,
                          ),
                        ),
                      );

                      if (selectedCategory != null) {
                        setState(() {
                          _selectedCategory =
                              (selectedCategory as Category).name;
                        });
                      }
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Color(0xffc48c53),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Container(
                      height: 130,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "All",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ))),
                  Expanded(
                    child: Container(
                      height: 130,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryTile(
                            category: category,
                            onTap: () {
                              setState(() {
                                _selectedCategory = category.name;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommendations",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                        color: Color(0xffc48c53),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Container(
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (ctx, i) => ProductItem(products[i])),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout", style: AppWidget.semiboldTextFieldStyle()),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  CategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 90,
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              category.imageAssetPath,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10.0),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
