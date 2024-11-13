import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'order_management_page.dart';
import 'product_management_page.dart';
import 'sales_management_page.dart';
import 'users_management_page.dart';
import 'add_product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trang Admin',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.teal[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
      initialRoute: '/', // Đường dẫn khởi đầu
      routes: {
        '/': (context) => LoginPage(),
        '/orders': (context) => OrderManagementScreen(),
        '/products': (context) => ProductManagementScreen(),
        '/sales': (context) => SalesManagementScreen(),
        '/users': (context) => UsersManagementScreen(),
        '/add_product': (context) => AddProductPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginPage());
      },
    );
  }
}
