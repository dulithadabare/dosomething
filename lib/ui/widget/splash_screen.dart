import 'package:flutter/material.dart';

import 'loading_large.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('dosomething',
                style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 48,
                    fontWeight: FontWeight.normal
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              LoadingLarge(),
            ],
          )
          ,
        ),
      ),
    );
  }
}
