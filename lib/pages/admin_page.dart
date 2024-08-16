import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    String url = 'http://192.168.1.12/sertifikasi_jmp/get_orders.php';

    try {
      var response = await http.get(Uri.parse(url));
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print('Decoded Data: $data');

        setState(() {
          orders = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        print('Failed to load orders: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching orders: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin - Orders',
          style:
              TextStyle(color: Color(0xff39639f), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xffe9d1c9),
        iconTheme: IconThemeData(color: Color(0xff39639f)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(child: Text('No orders found.'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ID: ${order['order_id']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Icon(
                                  Icons.shopping_bag,
                                  color: Color(0xff39639f),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Divider(color: Colors.brown.shade200),
                            SizedBox(height: 8.0),
                            _buildOrderDetail('Nama', order['nama']),
                            _buildOrderDetail('Alamat', order['alamat']),
                            _buildOrderDetail(
                                'No Telepon', order['no_telepon']),
                            _buildOrderDetail(
                                'Product ID', order['product_id']),
                            _buildOrderDetail('Jumlah', order['quantity']),
                            _buildOrderDetail('Lokasi',
                                '${order['latitude']}, ${order['longitude']}'),
                            SizedBox(height: 10.0),
                            _buildOpenLocationButton(
                                order['latitude'], order['longitude']),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenLocationButton(String latitude, String longitude) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final String googleMapsUrl =
              'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
          if (await canLaunch(googleMapsUrl)) {
            await launch(googleMapsUrl);
          } else {
            throw 'Could not launch $googleMapsUrl';
          }
        },
        icon: Icon(Icons.map),
        label: Text('Buka Lokasi'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 126, 157, 116),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
