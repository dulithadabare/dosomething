import 'package:dosomething/styles.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  ErrorMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error),
            SizedBox(
              height: 20,
            ),
            Text('Error Occurred', style: Styles.bodyGrey18,),
            SizedBox(
              height: 10,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
