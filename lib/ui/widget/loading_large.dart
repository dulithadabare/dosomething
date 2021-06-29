import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      backgroundColor: Colors.black,
    );
  }
}
