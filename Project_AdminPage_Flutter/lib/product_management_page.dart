import 'package:flutter/material.dart';
import 'firebase_services.dart';
import 'package:intl/intl.dart';
import 'product_detail_page.dart';
import 'edit_product_page.dart';

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      List<Map<String, dynamic>> productList = await getProducts();
      setState(() {
        products = productList;
      });
    } catch (error) {
      print('Lỗi lấy sản phẩm: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Có lỗi xảy ra khi lấy danh sách sản phẩm.'),
            actions: <Widget>[
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void handleViewDetails(Map<String, dynamic> product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(productId: product['id']),
      ),
    );
    if (result == true) {
      fetchProducts();  // Đảm bảo danh sách được làm mới khi quay lại từ trang chi tiết
    }
  }

  void handleAdd() async {
    final result = await Navigator.pushNamed(context, '/add_product');
    if (result == true) {
      fetchProducts();
    }
  }

  void handleEdit(Map<String, dynamic> product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          onProductUpdated: () {
            fetchProducts();  // Đảm bảo gọi lại fetchProducts khi có sự thay đổi
          },
        ),
      ),
    );
    if (result == true) {
      fetchProducts();  // Đảm bảo gọi lại fetchProducts khi có sự thay đổi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text('Quản Lý Sản Phẩm'),
        backgroundColor: Color(0xFFFF5722),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return GestureDetector(
                    onTap: () => handleViewDetails(item),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xFFFF5722), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Image.network(
                              item['image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${NumberFormat.simpleCurrency(locale: 'vi_VN').format(item['price'])} VNĐ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF388E3C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: 30, color: Color(0xFFFF5722)),
                    onPressed: handleAdd,
                  ),
                  Text(
                    'Thêm sản phẩm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF5722),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}