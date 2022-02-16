import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_restaurant/models/product_model.dart';

class ProductService {
  String appName = 'foodAPP';

  String collection = "products";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async => _firestore
          .collection(appName)
          .doc(appName)
          .collection(collection)
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }

        return products;
      });
  Future createProduct({required Map<String, dynamic> data}) async {
    _firestore
        .collection(appName)
        .doc(appName)
        .collection(collection)
        .doc(data['id'])
        .set({
      "id": data['id'],
      "name": data['name'],
      "image": data['image'],
      "rates": data['rates'],
      "rating": data['rating'],
      "price": data['price'],
      "restaurant": data['restaurant'],
      "restaurantId": data['restaurantId'],
      "description": data['description'],
      "featured": data['featured'],
    });
  }

  Future<List<ProductModel>> getProductsByRestaurant(
          {required String id}) async =>
      _firestore
          .collection(appName)
          .doc(appName)
          .collection(collection)
          .where("restaurantId", isEqualTo: id)
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<List<ProductModel>> getProductsOfCategory(
          {required String category}) async =>
      _firestore
          .collection(appName)
          .doc(appName)
          .collection(collection)
          .where("category", isEqualTo: category)
          .get()
          .then((result) {
        print(result);
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<List<ProductModel>> searchProducts({required String productName}) {
    // code to convert the first character to uppercase
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _firestore
        .collection(appName)
        .doc(appName)
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result) {
          List<ProductModel> products = [];
          for (DocumentSnapshot product in result.docs) {
            products.add(ProductModel.fromSnapshot(product));
          }
          return products;
        });
  }
}
