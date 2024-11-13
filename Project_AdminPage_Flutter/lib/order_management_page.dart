import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('users');

  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;
  String _activeTab = 'newOrders';
  Map<String, String> _statusByOrder = {};

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    _databaseRef.onValue.listen((event) {
      final ordersList = <Map<String, dynamic>>[];
      final usersData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (usersData != null) {
        usersData.forEach((userId, userInfo) {
          if (userInfo['orders'] != null) {
            userInfo['orders'].forEach((orderId, order) {
              ordersList.add({
                'orderId': orderId,
                'userId': userId,
                ...order,
                'userInfo': userInfo,
              });
            });
          }
        });

        // Sort orders by order time (latest first)
        ordersList.sort((a, b) => _parseOrderTime(b['orderTime']).compareTo(_parseOrderTime(a['orderTime'])));
      }

      setState(() {
        _orders = ordersList;
        _loading = false;
      });
    });
  }

  DateTime _parseOrderTime(String orderTime) {
    final parts = orderTime.split(', ');
    final timeParts = parts[0].split(':');
    final dateParts = parts[1].split('/');
    return DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );
  }

  void _handleStatusUpdate(String orderId, String userId) async {
    if (_statusByOrder[orderId] == null || _statusByOrder[orderId]!.isEmpty) return;

    final newStatus = _statusByOrder[orderId];

    // Update the specific order status in Firebase
    await _databaseRef.child(userId).child('orders').child(orderId).update({'status': newStatus});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Trạng thái đơn hàng đã được cập nhật')),
    );

    setState(() {
      _statusByOrder[orderId] = '';
    });
  }

  List<Map<String, dynamic>> _filterOrders(String status) {
    // Filter orders based on status
    if (status == 'newOrders') {
      return _orders.where((order) => order['status'] == 'Đang xử lý').toList();
    } else if (status == 'processingOrders') {
      return _orders.where((order) =>
          ['Đã xác nhận đơn hàng', 'Shop đang chuẩn bị đơn hàng', 'Đang giao hàng']
              .contains(order['status'])).toList();
    } else if (status == 'deliveredOrders') {
      return _orders.where((order) => order['status'] == 'Đã giao thành công').toList();
    } else {
      return _orders.where((order) => order['status'] == 'Đã hủy').toList();
    }
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final orderId = order['orderId'];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đơn hàng ID: $orderId', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Tên người dùng: ${order['userInfo']['name']}'),
            Text('Địa chỉ giao hàng: ${order['shippingAddress']}'),
            Text('Số điện thoại: ${order['userInfo']['phone']}'),
            Text('Thời gian: ${order['orderTime']}'),
            Text('Tổng cộng: ${_formatPrice(order['totalAmount'])}'),
            Text('Hình thức thanh toán: ${order['paymentMethod']}'),
            Text('Trạng thái: ${order['status']}', style: TextStyle(color: Colors.red)),

            // Product items
            ...List.generate((order['items'] as List).length, (index) {
              final item = order['items'][index];
              return ListTile(
                leading: item['image'] != null ? Image.network(item['image'], width: 50, height: 50) : null,
                title: Text('${item['name']} x ${item['quantity']}'),
                subtitle: Text('${_formatPrice(item['totalPrice'])}'),
              );
            }),

            // Status update if applicable
            if (order['status'] != 'Đã giao thành công' && order['status'] != 'Đã hủy')
              Column(
                children: [
                  DropdownButton<String>(
                    value: _statusByOrder[orderId]?.isEmpty ?? true ? null : _statusByOrder[orderId],
                    hint: Text("Cập nhật trạng thái đơn hàng"),
                    items: [
                      DropdownMenuItem(value: "Đang xử lý", child: Text("Đang xử lý")),
                      DropdownMenuItem(value: "Đã xác nhận đơn hàng", child: Text("Đã xác nhận đơn hàng")),
                      DropdownMenuItem(value: "Shop đang chuẩn bị đơn hàng", child: Text("Shop đang chuẩn bị đơn hàng")),
                      DropdownMenuItem(value: "Đang giao hàng", child: Text("Đang giao hàng")),
                      DropdownMenuItem(value: "Đã giao thành công", child: Text("Đã giao thành công")),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        _statusByOrder[orderId] = newValue ?? ''; // Use an empty string if null
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _handleStatusUpdate(orderId, order['userId']),
                    child: Text("Cập nhật"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '';
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _fetchOrders),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Tab Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabButton('newOrders', 'Mới', _countOrdersByStatus('Đang xử lý')),
              _buildTabButton('processingOrders', 'Xử lý', _countOrdersByStatus('processingOrders')),
              _buildTabButton('deliveredOrders', 'Đã giao', _countOrdersByStatus('Đã giao thành công')),
              _buildTabButton('canceledOrders', 'Bị Hủy', _countOrdersByStatus('Đã hủy')),
            ],
          ),
          Expanded(
            child: _filterOrders(_activeTab).isEmpty
                ? Center(child: Text('Không có đơn hàng'))
                : ListView(
              children: _filterOrders(_activeTab).map((order) => _buildOrderItem(order)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  int _countOrdersByStatus(String status) {
    switch (status) {
      case 'Đang xử lý':
        return _orders.where((order) => order['status'] == 'Đang xử lý').length;
      case 'processingOrders':
        return _orders.where((order) =>
            ['Đã xác nhận đơn hàng', 'Shop đang chuẩn bị đơn hàng', 'Đang giao hàng']
                .contains(order['status'])).length;
      case 'Đã giao thành công':
        return _orders.where((order) => order['status'] == 'Đã giao thành công').length;
      case 'Đã hủy':
        return _orders.where((order) => order['status'] == 'Đã hủy').length;
      default:
        return 0;
    }
  }

  Widget _buildTabButton(String tab, String title, int badgeCount) {
    return TextButton(
      onPressed: () => setState(() => _activeTab = tab),
      child: Column(
        children: [
          Text(title),
          if (badgeCount > 0)
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                badgeCount.toString(),
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
