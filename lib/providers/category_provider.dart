import 'package:flutter/material.dart';
import 'package:food_restaurant/helpers/category_services.dart';
import 'package:food_restaurant/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  CategoryServices _categoryServices = CategoryServices();
  List<CategoryModel> _categories = [];
  List<String> categoriesNames = [];
  String selectedCategory = '';

  CategoryProvider.initialize() {
    _loadCategories();
  }

  List<CategoryModel> get categories => _categories;

  _loadCategories() async {
    _categories = await _categoryServices.getCategories();
    for (CategoryModel category in categories) {
      categoriesNames.add(category.name!);
    }
    selectedCategory = categoriesNames[0];
    notifyListeners();
  }

  changeSelectedCategory(String newCategory) {
    selectedCategory = newCategory;
    notifyListeners();
  }
}
