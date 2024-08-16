import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sertifikasi_jmp/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  Position? _currentPosition;
  bool _isSubmitting = false;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {});

    if (_currentPosition != null) {
      final String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}';
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    }
  }

  Future<void> _submitOrder(Product product, int quantity) async {
    setState(() {
      _isSubmitting = true;
    });

    final url =
        Uri.parse('http://192.168.1.12/sertifikasi_jmp/submit_order.php');
    final response = await http.post(
      url,
      body: {
        'nama': _nameController.text,
        'alamat': _addressController.text,
        'no_telepon': _phoneController.text,
        'latitude': _currentPosition?.latitude.toString() ?? '',
        'longitude': _currentPosition?.longitude.toString() ?? '',
        'product_id': product.id.toString(),
        'quantity': quantity.toString(),
      },
    );

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 200 &&
        response.body.contains('Order placed successfully')) {
      Navigator.of(context).pop();
    } else {
      print('Failed to submit order: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Product product = args['product'];
    final int quantity = args['quantity'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffe9d1c9), Color(0xffc791c9)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 20),
                Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Anda',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffc48c53),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildTextField(_nameController, 'Nama'),
                        SizedBox(height: 15),
                        _buildTextField(_addressController, 'Alamat'),
                        SizedBox(height: 15),
                        _buildTextField(_phoneController, 'No Telepon',
                            TextInputType.phone),
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: Icon(Icons.location_on, color: Colors.white),
                            label: Text('Buka di Google Maps',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffc48c53),
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _currentPosition != null
                            ? Center(
                                child: Text(
                                  'Lokasi: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                                  style: TextStyle(color: Color(0xffc48c53)),
                                ),
                              )
                            : Center(
                                child: Text('Lokasi tidak ditemukan',
                                    style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _isSubmitting
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () => _submitOrder(product, quantity),
                        child: Text('Order Sekarang',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 186, 117, 49),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: TextStyle(color: Color(0xff39639f))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 219, 204, 200),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
    );
  }
}
