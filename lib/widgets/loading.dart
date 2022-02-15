import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_restaurant/helpers/style.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: white,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SpinKitFadingCircle(
            color: red,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
