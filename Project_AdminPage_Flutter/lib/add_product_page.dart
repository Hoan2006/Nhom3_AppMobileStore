import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'firebase_services.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _category = '';
  File? _image;

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Hàm tải ảnh lên Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    final fileName = basename(imageFile.path);
    final storageRef = FirebaseStorage.instance.ref().child('products/$fileName');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Hàm xử lý thêm sản phẩm
  Future<void> _handleAddProduct(BuildContext context) async {
    // Kiểm tra dữ liệu
    if (_nameController.text.isEmpty ||
        _brandController.text.isEmpty ||
        _category.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin sản phẩm.')),
      );
      return;
    }

    try {
      // Tải ảnh lên và thêm sản phẩm vào Firebase
      final imageUrl = await _uploadImage(_image!);
      final productData = {
        'name': _nameController.text,
        'brand': _brandController.text,
        'category': _category,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'image': imageUrl,
      };

      await addProduct(productData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sản phẩm đã được thêm thành công!')),
      );

      Navigator.pop(context, true); // Trả về `true` khi thêm sản phẩm thành công
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi thêm sản phẩm.')),
      );
    }
  }

  // Giao diện của trang AddProductPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Sản Phẩm'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('Chọn ảnh sản phẩm', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField('Tên thiết bị', _nameController),
            _buildTextField('Hãng sản xuất', _brandController),
            Text('Danh mục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _category.isEmpty ? null : _category,
              hint: Text('Chọn danh mục'),
              isExpanded: true,
              items: <String>['Phổ thông', 'Tầm trung', 'Cận cao cấp', 'Cao cấp']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _category = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            _buildTextField('Mô tả sản phẩm', _descriptionController, maxLines: 3),
            _buildTextField('Giá sản phẩm', _priceController, keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _handleAddProduct(context),  // Truyền context vào hàm
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Thêm Sản Phẩm', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm xây dựng TextField
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.teal[50], // Thay đổi màu nền
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal, width: 1), // Đường viền mặc định
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal, width: 2), // Màu và độ dày đường viền khi focus
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal[300]!, width: 1), // Màu đường viền khi không focus
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12), // Điều chỉnh padding trong TextField
            ),
          ),
        ],
      ),
    );
  }
}
