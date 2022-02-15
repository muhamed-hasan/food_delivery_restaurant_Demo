import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_restaurant/helpers/order_services.dart';
import 'package:food_restaurant/models/order_model.dart';

import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth? _auth;
  User? _user;

  Status _status = Status.Uninitialized;
  final _fireStore = FirebaseFirestore.instance;
  String appName = 'foodAPP';
  String collection = 'restaurants';
  OrderServices _orderServices = OrderServices();

//  getter
  Status get status => _status;
  User? get user => _user;

  // public variables
  List<OrderModel> orders = [];

  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth?.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          ?.createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        _fireStore
            .collection(appName)
            .doc(appName)
            .collection(collection)
            .doc(result.user!.uid)
            .set({
          'name': name.text,
          'email': email.text,
          'id': result.user!.uid,
          "avgPrice": 0.0,
          "image": "",
          "popular": false,
          "rates": 0,
          "rating": 0.0,
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  signOut() async {
    _auth?.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();

    // return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
  }

//  Future<void> reloadUserModel()async{
//    _userModel = await _userServicse.getUserById(user.uid);
//    notifyListeners();
//  }

  Future<void> _onStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      // _userModel = await _userServices.getUserById(user!.uid);
    }
    notifyListeners();
  }

  getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user!.uid);
    notifyListeners();
  }

  Future<bool> removeFromCart({required Map cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
//      _userServicse.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
}