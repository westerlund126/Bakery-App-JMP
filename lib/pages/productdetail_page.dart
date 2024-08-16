import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/models/product.dart';
import 'package:sertifikasi_jmp/widget/support_widget.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      backgroundColor: Color(0xfffef5f1),
      body: Container(
        padding: EdgeInsets.only(top: 18.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30)),
                  child: Icon(Icons.arrow_back_ios_new_outlined)),
            ),
            Container(
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  product.imageAssetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)}', // Display product price
                          style: TextStyle(
                            color: Color(0xffd36826),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Details",
                      style: AppWidget.semiboldTextFieldStyle(),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      product.description, // Display product description
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity adjustment buttons
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffa8a7d3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: _decrementQuantity,
                                icon: Icon(Icons.remove, color: Colors.white),
                                padding: EdgeInsets.all(4),
                                iconSize: 18,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '$_quantity',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffc791c9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: _incrementQuantity,
                                icon: Icon(Icons.add, color: Colors.white),
                                padding: EdgeInsets.all(4),
                                iconSize: 18,
                              ),
                            ),
                          ],
                        ),

                        // Buy Now button (you can customize this further)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/checkout',
                              arguments: {
                                'product': product,
                                'quantity': _quantity,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffc58c53),
                            foregroundColor: Colors.white,
                            // Increase vertical padding for height
                            padding: EdgeInsets.symmetric(
                                vertical: 23.0,
                                horizontal: 35.0), // Adjust values as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.5, 0),
                          ),
                          child: Text("Beli Sekarang"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
