import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";
  static const RESTAURANT_ID = "restaurantId";

  String? _id;
  String? _restaurantId;
  String? _description;
  String? _userId;
  String? _status;
  int? _createdAt;
  double? _total;
  // public variable
  List? cart;
//  getters
  String? get id => _id;
  String? get restaurantId => _restaurantId;
  String? get description => _description;
  String? get userId => _userId;
  String? get status => _status;
  double? get total => _total;
  int? get createdAt => _createdAt;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    _id = data[ID];
    _description = data[DESCRIPTION];
    _total = data[TOTAL];
    _status = data[STATUS];
    _userId = data[USER_ID];
    _createdAt = data[CREATED_AT];
    _restaurantId = data[RESTAURANT_ID];
    cart = data[CART];
  }
}
