import 'package:firebase_database/firebase_database.dart';

final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

// Hàm lấy danh sách sản phẩm
Future<List<Map<String, dynamic>>> getProducts() async {
  List<Map<String, dynamic>> productList = [];

  try {
    DatabaseEvent event = await databaseReference.child('products').once();
    final data = event.snapshot.value;

    if (data != null) {
      Map<dynamic, dynamic> productsMap = data as Map<dynamic, dynamic>;
      productsMap.forEach((key, value) {
        productList.add({
          'id': key,
          'name': value['name'],
          'image': value['image'],
          'price': value['price'],
        });
      });
    }
  } catch (error) {
    print('Lỗi khi lấy danh sách sản phẩm: $error');
  }

  return productList;
}

// Hàm thêm sản phẩm mới vào Realtime Database
Future<void> addProduct(Map<String, dynamic> productData) async {
  try {
    String? newProductKey = databaseReference.child('products').push().key;

    if (newProductKey != null) {
      await databaseReference.child('products/$newProductKey').set(productData);
      print('Sản phẩm đã được thêm thành công');
    }
  } catch (error) {
    print('Lỗi khi thêm sản phẩm: $error');
  }
}

// Hàm cập nhật thông tin sản phẩm
Future<void> updateProduct(String productId, Map<String, dynamic> updatedProductData) async {
  try {
    // Cập nhật sản phẩm trong Realtime Database
    await databaseReference.child('products/$productId').update(updatedProductData);
    print('Sản phẩm đã được cập nhật thành công');
  } catch (error) {
    print('Lỗi khi cập nhật sản phẩm: $error');
  }
}

// Hàm xóa sản phẩm
Future<void> deleteProduct(String productId) async {
  try {
    await databaseReference.child('products/$productId').remove();
    print('Sản phẩm đã được xóa thành công');
  } catch (error) {
    print('Lỗi khi xóa sản phẩm: $error');
  }
}

// Hàm lấy thông tin chi tiết sản phẩm
Future<Map<String, dynamic>> fetchProduct(String productId) async {
  Map<String, dynamic> productData = {};

  try {
    DatabaseEvent event = await databaseReference.child('products/$productId').once();
    final data = event.snapshot.value;

    if (data != null) {
      // Chuyển đổi Object về Map<String, dynamic> bằng cách sử dụng Map.from
      Map<String, dynamic> productMap = Map<String, dynamic>.from(data as Map);

      // Trả về dữ liệu sản phẩm
      productData = {
        'id': productId,
        'name': productMap['name'],
        'image': productMap['image'],
        'price': productMap['price'],
        'description': productMap['description'],
        'brand': productMap['brand'],
        'category': productMap['category'],
      };
    }
  } catch (error) {
    print('Lỗi khi lấy thông tin sản phẩm: $error');
  }

  return productData;
}

