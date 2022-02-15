import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_restaurant/models/order_model.dart';

class OrderServices {
  String collection = "orders";
  String appName = 'foodAPP';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createOrder(
      {required String userId,
      required String id,
      required String description,
      required String status,
      required List cart,
      required int totalPrice}) {
    _firestore
        .collection(appName)
        .doc(appName)
        .collection(collection)
        .doc(id)
        .set({
      "userId": userId,
      "id": id,
      "cart": cart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status
    });
  }

  Future<List<OrderModel>> getUserOrders({required String userId}) async =>
      _firestore
          .collection(appName)
          .doc(appName)
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .get()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.docs) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });
}
