import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/pages/bottomnav.dart';
import 'package:sertifikasi_jmp/pages/checkout_page.dart';
import 'package:sertifikasi_jmp/pages/home_page.dart';
import 'package:sertifikasi_jmp/pages/login_page.dart';
import 'package:sertifikasi_jmp/pages/productdetail_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (ctx) => Login(),
        '/home': (ctx) => BottomNav(),
        '/product-detail': (ctx) => ProductDetailPage(),
        '/checkout': (ctx) => CheckoutPage(),
      },
    );
  }
}
