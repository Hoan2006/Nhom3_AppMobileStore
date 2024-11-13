import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void handleLogout(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã đăng xuất.')),
      );
      Navigator.pushReplacementNamed(context, '/'); // Điều hướng về trang đăng nhập
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng xuất không thành công!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Mục Quản Lý'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section for Product Management
            _buildMenuItem(
              icon: Icons.inventory,
              color: Colors.green,
              text: 'Quản lý sản phẩm',
              onTap: () {
                Navigator.pushNamed(context, '/products'); // Đường dẫn tới trang quản lý sản phẩm
              },
            ),

            // Section for User Management
            _buildMenuItem(
              icon: Icons.people,
              color: Colors.orange,
              text: 'Quản lý người dùng',
              onTap: () {
                Navigator.pushNamed(context, '/users'); // Đường dẫn tới trang quản lý người dùng
              },
            ),

            // Section for Order Management
            _buildMenuItem(
              icon: Icons.assignment,
              color: Colors.blue,
              text: 'Quản lý đơn hàng',
              onTap: () {
                Navigator.pushNamed(context, '/orders'); // Đường dẫn tới trang quản lý đơn hàng
              },
            ),

            // New Section for Sales Management
            _buildMenuItem(
              icon: Icons.bar_chart,
              color: Colors.purple,
              text: 'Quản lý doanh số',
              onTap: () {
                Navigator.pushNamed(context, '/sales'); // Đường dẫn tới trang quản lý doanh số
              },
            ),

            // Logout Button
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => handleLogout(context),
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              label: Text('Đăng xuất', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 30, color: color),
              SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
