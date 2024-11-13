import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Nếu bạn đang sử dụng Firestore
import 'package:firebase_database/firebase_database.dart'; // Nếu bạn đang sử dụng Realtime Database
import 'package:intl/intl.dart';

class ProductItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final int sales;
  final ValueChanged<int> onSalesChange;
  final VoidCallback onSave;

  const ProductItem({
    Key? key,
    required this.item,
    required this.sales,
    required this.onSalesChange,
    required this.onSave,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late TextEditingController _salesController;

  @override
  void initState() {
    super.initState();
    _salesController = TextEditingController(text: widget.sales.toString());
    _salesController.addListener(() {
      final intValue = int.tryParse(_salesController.text) ?? 0;
      widget.onSalesChange(intValue);
    });
  }

  @override
  void didUpdateWidget(ProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sales != widget.sales) {
      _salesController.text = widget.sales.toString();
    }
  }

  @override
  void dispose() {
    _salesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                widget.item['image'],
                width: 64,
                height: 64,
              ),
              SizedBox(height: 8),
              Text(
                widget.item['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nhập doanh số',
                  border: OutlineInputBorder(),
                ),
                controller: _salesController,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: widget.onSave,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.update),
                    SizedBox(width: 4),
                    Text('Cập nhật'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesManagementScreen extends StatefulWidget {
  @override
  _SalesManagementScreenState createState() => _SalesManagementScreenState();
}

class _SalesManagementScreenState extends State<SalesManagementScreen> {
  List<Map<String, dynamic>> products = [];
  Map<String, int> sales = {};

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      // Lấy danh sách sản phẩm từ Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref('products');
      DatabaseEvent event = await ref.once(); // Sử dụng DatabaseEvent
      DataSnapshot snapshot = event.snapshot; // Lấy DataSnapshot từ event

      if (snapshot.exists) {
        Map<dynamic, dynamic> productData = snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> productList = [];

        productData.forEach((key, value) {
          productList.add({
            'id': key,
            'name': value['name'],
            'image': value['image'],
            'sales': value['sales'] ?? 0,
          });
        });

        setState(() {
          products = productList;
          sales = {for (var product in productList) product['id']: product['sales']};
        });
      } else {
        print('Không có sản phẩm nào trong cơ sở dữ liệu.');
      }
    } catch (error) {
      print('Lỗi lấy sản phẩm: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thông báo'),
          content: Text('Có lỗi xảy ra khi lấy danh sách sản phẩm.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  void handleSalesChange(String id, int newSales) {
    setState(() {
      sales[id] = newSales;
    });
  }

  Future<void> handleSaveSales(String id) async {
    try {
      await FirebaseDatabase.instance.ref('products').child(id).update({'sales': sales[id]});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật doanh số thành công!')));
    } catch (error) {
      print('Lỗi cập nhật doanh số: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thông báo'),
          content: Text('Có lỗi xảy ra khi cập nhật doanh số.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Doanh Số Sản Phẩm'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final item = products[index];
            return ProductItem(
              item: item,
              sales: sales[item['id']] ?? 0,
              onSalesChange: (newSales) => handleSalesChange(item['id'], newSales),
              onSave: () => handleSaveSales(item['id']),
            );
          },
        ),
      ),
    );
  }
}
