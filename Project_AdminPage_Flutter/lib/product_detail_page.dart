import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'firebase_services.dart'; // This should contain your Firebase logic like fetching and deleting data
import 'edit_product_page.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? product;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  // Fetch product details from Firebase Realtime Database
  Future<void> _loadProductDetails() async {
    try {
      product = await fetchProduct(widget.productId); // Assuming fetchProduct is your Firebase fetch function
      setState(() {});
    } catch (error) {
      // Handle error loading product
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể tải thông tin sản phẩm.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Delete product from Firebase Realtime Database
  Future<void> _handleDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () async {
                try {
                  if (product?['id'] != null) {
                    await deleteProduct(product!['id']); // Assuming deleteProduct is your Firebase delete function
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sản phẩm đã được xóa.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true); // Go back to the previous screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ID sản phẩm không hợp lệ.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Có lỗi xảy ra khi xóa sản phẩm.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi Tiết Sản Phẩm'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Sản Phẩm'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (product?['image'] != null && product?['image']!.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.6,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product!['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Product name
                    Text(
                      product?['name'] ?? 'Không có tên sản phẩm',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Brand
                    Text(
                      product?['brand'] ?? 'Không có thương hiệu',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Category
                    Text(
                      product?['category'] ?? 'Không có danh mục',
                      style: const TextStyle(
                        fontSize: 19,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                          .format(product?['price'] ?? 0),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description
                    Text(
                      product?['description'] ?? 'Không có mô tả',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),

                    // Action buttons (Edit, Delete)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditProductScreen(
                                  product: product!,
                                  onProductUpdated: () {
                                    // Cập nhật sản phẩm sau khi sửa
                                    setState(() {
                                      // Assuming you have a function that fetches the updated product
                                      _loadProductDetails(); // Fetch the latest product details from Firebase
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text('Sửa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _handleDelete(context),
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text('Xóa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
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
