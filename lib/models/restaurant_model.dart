import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  static const ID = "id";
  static const NAME = "name";
  static const AVG_PRICE = "avgPrice";
  static const RATING = "rating";
  static const RATES = "rates";
  static const IMAGE = "image";
  static const POPULAR = "popular";
  static const USER_LIKES = "userLikes";

  String? _id;

  List<String>? _userLikes;

  String? _name;
  String? _image;
  double? _rating;
  double? _avgPrice;
  bool? _popular;
  int? _rates;

//  getters
  String? get id => _id;

  String? get name => _name;

  String? get image => _image;

  double? get avgPrice => _avgPrice;

  double? get rating => _rating;

  bool? get popular => _popular;

  int? get rates => _rates;

  // public variable
  bool liked = false;

  RestaurantModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

    _id = data[ID];
    _name = data[NAME];
    _image = data[IMAGE];
    _avgPrice = data[AVG_PRICE];
    _rating = data[RATING];
    _popular = data[POPULAR];
    _rates = data[RATES];
  }
}
