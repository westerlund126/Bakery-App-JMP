import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/pages/login_page.dart';
import 'package:sertifikasi_jmp/widget/support_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final controllerUsername = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isAdmin = false;
  bool _obscureText = true;

  // MySQL registration function
  register(BuildContext context) async {
    String url = 'http://192.168.1.12/sertifikasi_jmp/user/register.php';
    var response = await http.post(Uri.parse(url), body: {
      'username': controllerUsername.text,
      'password': controllerPassword.text,
      'is_admin': isAdmin ? '1' : '0',
    });
    Map responseBody = await jsonDecode(response.body);
    if (responseBody['success']) {
      DInfo.toastSuccess('Registration Success');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    } else {
      DInfo.toastError('Registration Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:
            EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/signup.png"),
                Center(
                  child: Text(
                    "Sign Up",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Text(
                    "Tolong isi form dibawah\n     untuk melanjutkan.",
                    style: AppWidget.lightTextFieldStyle(),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Username",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xffe9d1c9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: controllerUsername,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Your name",
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Email",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xffe9d1c9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: controllerEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "yourname@mail.com",
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Password",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xffe9d1c9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: controllerPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      register(context);
                    }
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Color(0xffc48c53),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          color: Color.fromARGB(255, 205, 125, 46),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
