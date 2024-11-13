import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'dart:convert';
import 'dart:math';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("users");
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String otp = '';
  bool otpSent = false;

  Future<void> sendOtp(String email) async {
    otp = generateOTP();

    final response = await http.post(
      Uri.parse('https://api.mailjet.com/v3.1/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic ${base64Encode(utf8.encode('1332a41efd1adde94b1ed80ad1db1792:62f8ba1b90b003bee6a850603f9e9a19'))}',
      },
      body: jsonEncode({
        'Messages': [
          {
            'From': {
              'Email': 'locvbn13@gmail.com',
              'Name': 'KhaiHoan',
            },
            'To': [
              {
                'Email': email,
                'Name': 'Recipient Name',
              },
            ],
            'Subject': 'Your OTP Code',
            'TextPart': 'Your OTP code is $otp',
            'HTMLPart': '<h3>Your OTP code is <strong>$otp</strong></h3>',
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        otpSent = true;
      });
      otpController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP đã được gửi thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể gửi OTP')),
      );
    }
  }

  Future<void> register() async {
    if (otpController.text == otp) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await _dbRef.child(userCredential.user!.uid).set({
          'email': emailController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công!')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xảy ra lỗi trong quá trình đăng ký. Vui lòng thử lại!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mã OTP không chính xác. Vui lòng nhập lại!')),
      );
      otpController.clear();
    }
  }

  String generateOTP() {
    int randomNum = Random().nextInt(900000) + 100000;
    return randomNum.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.teal),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.teal),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  if (otpSent) ...[
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: 'Nhập OTP',
                        prefixIcon: Icon(Icons.lock, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: register,
                      child: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        sendOtp(emailController.text);
                      },
                      child: Text('Send OTP'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                    child: Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
