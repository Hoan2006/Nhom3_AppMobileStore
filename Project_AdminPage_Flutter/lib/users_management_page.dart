import 'package:flutter/material.dart';

class UsersManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý người dùng'),
      ),
      body: Center(
        child: Text(
          'Nội dung quản lý người dùng',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
