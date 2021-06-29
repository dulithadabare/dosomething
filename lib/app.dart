import 'package:dosomething/business_logic/view_model/current_activity_view_model.dart';
import 'package:dosomething/business_logic/view_model/user_view_model.dart';
import 'package:dosomething/ui/page/home_page.dart';
import 'package:dosomething/ui/page/sign_in_page.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:dosomething/ui/widget/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'business_logic/view_model/abstract_view_model.dart';

class DoSomethingApp extends StatelessWidget {
  const DoSomethingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel(),),
        ChangeNotifierProvider<CurrentActivityViewModel>(create: (_) => CurrentActivityViewModel(),),
      ],
      child: MaterialApp(
        title: 'DoSomething',
        home: Consumer<UserViewModel>(
          builder: (context, model, child) {
            if( !model.initialized ) {
              return SplashScreen();
            } else if ( !model.signedIn ) {
              return SignInPage();
            } else if ( model.status == ViewModelStatus.error ) {
              return ErrorMessage(message: 'Error');
            } else {
              return HomePage();
            }
          },
        ),
      ),
    );
  }
}
