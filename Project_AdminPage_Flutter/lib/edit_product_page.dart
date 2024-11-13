import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onProductUpdated;

  const EditProductScreen({required this.product, required this.onProductUpdated, Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController brandController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  String? category;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    brandController = TextEditingController(text: widget.product['brand']);
    descriptionController = TextEditingController(text: widget.product['description']);
    priceController = TextEditingController(text: widget.product['price'].toString());
    category = widget.product['category'];
    imageUrl = widget.product['image'];
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 600, imageQuality: 70);
    if (pickedFile != null) {
      final String uploadedUrl = await uploadImage(pickedFile.path);
      setState(() {
        imageUrl = uploadedUrl;
      });
    }
  }

  Future<String> uploadImage(String filePath) async {
    final fileName = path.basename(filePath);
    final storageRef = FirebaseStorage.instance.ref().child('products/$fileName');
    await storageRef.putFile(File(filePath));
    return await storageRef.getDownloadURL();
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> productData) async {
    try {
      final databaseRef = FirebaseDatabase.instance.ref().child('products/$productId');
      await databaseRef.update(productData);
    } catch (error) {
      throw 'Có lỗi xảy ra khi cập nhật sản phẩm: $error';
    }
  }

  Future<void> handleUpdateProduct() async {
    if (nameController.text.isEmpty ||
        brandController.text.isEmpty ||
        category == null ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        imageUrl == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Vui lòng điền đầy đủ thông tin sản phẩm.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
      return;
    }

    final updatedProduct = {
      'name': nameController.text,
      'brand': brandController.text,
      'category': category,
      'description': descriptionController.text,
      'price': double.parse(priceController.text),
      'image': imageUrl,
    };

    try {
      await updateProduct(widget.product['id'], updatedProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sản phẩm đã được cập nhật thành công!')),
      );
      widget.onProductUpdated();  // Gọi callback để làm mới danh sách sản phẩm
      Navigator.of(context).pop();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Có lỗi xảy ra khi cập nhật sản phẩm.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Đóng'),
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
        title: const Text('Chỉnh sửa sản phẩm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: imageUrl != null
                      ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: imageUrl == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Chọn ảnh sản phẩm', style: TextStyle(color: Colors.grey)),
                  ],
                )
                    : Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: pickImage,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildTextField('Tên thiết bị', nameController),
            buildTextField('Hãng sản xuất', brandController),
            const SizedBox(height: 16),
            const Text('Danh mục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: category,
              items: const [
                DropdownMenuItem(value: 'Phổ thông', child: Text('Phổ thông')),
                DropdownMenuItem(value: 'Tầm trung', child: Text('Tầm trung')),
                DropdownMenuItem(value: 'Cận cao cấp', child: Text('Cận cao cấp')),
                DropdownMenuItem(value: 'Cao cấp', child: Text('Cao cấp')),
              ],
              onChanged: (value) => setState(() => category = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            buildTextField('Mô tả sản phẩm', descriptionController, maxLines: 5),
            buildTextField('Giá sản phẩm', priceController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: handleUpdateProduct, // Gọi hàm handleUpdateProduct khi nhấn nút lưu
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Trở lại'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
