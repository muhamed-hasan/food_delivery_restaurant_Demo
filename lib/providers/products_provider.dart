import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_restaurant/helpers/product_services.dart';
import 'package:food_restaurant/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProductsProvider with ChangeNotifier {
  ProductService _productServices = ProductService();
  List<ProductModel> _products = [];
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsByRestaurant = [];
  List<ProductModel> productsSearched = [];
  TextEditingController? name = TextEditingController();
  TextEditingController? description = TextEditingController();
  TextEditingController? price = TextEditingController();
  bool featured = false;
  File? productImage;
  String? productImageName;

  ProductsProvider.initialize() {
    _loadProducts();
  }

  List<ProductModel> get products => _products;

  _loadProducts() async {
    _products = await _productServices.getProducts();

    notifyListeners();
  }

  Future loadProductsByCategory({required String categoryName}) async {
    productsByCategory =
        await _productServices.getProductsOfCategory(category: categoryName);
    notifyListeners();
  }

  // Future loadProductsByRestaurant({required String restaurantId}) async {
  //   productsByRestaurant =
  //       await _productServices.getProductsByRestaurant(id: restaurantId);
  //   notifyListeners();
  // }

  changeFeatured() {
    featured = !featured;
    notifyListeners();
  }

//  method to load image files
  void getImageFile({required ImageSource source}) async {
    final picker = ImagePicker();

    final pickedFile =
        await picker.pickImage(source: source, maxWidth: 640, maxHeight: 400);
    productImage = File(pickedFile!.path);
    productImageName =
        productImage!.path.substring(productImage!.path.indexOf('/') + 1);
    notifyListeners();
  }

  //  method to upload the file to firebase
  Future<String> _uploadImageFile(
      {required File imageFile, required String imageFileName}) async {
    final reference = FirebaseStorage.instance.ref().child(imageFileName);
    await reference.putFile(imageFile);
    String imageUrl = await reference.getDownloadURL();
    print(imageUrl);
    return imageUrl;
  }

  Future<bool> uploadProduct(
      {required String category,
      required String restaurant,
      required String restaurantId}) async {
    try {
      String id = const Uuid().v1();
      String imageUrl =
          await _uploadImageFile(imageFile: productImage!, imageFileName: id);
      Map<String, dynamic> data = {
        "id": id,
        "name": name!.text[0].toUpperCase() + name!.text.trim(),
        "image": imageUrl,
        "rates": 0,
        "rating": 0.0,
        "price": double.parse(price?.text.trim() ?? '10'),
        "restaurant": restaurant,
        "restaurantId": restaurantId,
        "description": description!.text.trim(),
        "featured": featured
      };
      _productServices.createProduct(data: data);
      clear();
      return true;
    } catch (e) {
      print('upload error' + e.toString());
      return false;
    }
  }

  Future search({required String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);

    notifyListeners();
  }

  clear() {
    productImage = null;
    productImageName = null;
    name = TextEditingController();
    description = TextEditingController();
    price = TextEditingController();
  }
}
