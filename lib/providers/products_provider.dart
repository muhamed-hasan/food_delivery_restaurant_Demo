import 'package:flutter/material.dart';
import 'package:food_restaurant/helpers/product_services.dart';
import 'package:food_restaurant/models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  ProductService _productServices = ProductService();
  List<ProductModel> _products = [];
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsByRestaurant = [];
  List<ProductModel> productsSearched = [];
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

  Future loadProductsByRestaurant({required String restaurantId}) async {
    productsByRestaurant =
        await _productServices.getProductsByRestaurant(id: restaurantId);
    notifyListeners();
  }

  Future search({required String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);

    notifyListeners();
  }
}
