import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/business_logic/view_model/abstract_view_model.dart';
import 'package:dosomething/business_logic/view_model/user_view_model.dart';
import 'package:dosomething/ui/widget/loading_large.dart';
import 'package:dosomething/ui/widget/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  bool _error = false;
  String _message = '';

  void _pushHomePage(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home', (Route<dynamic> route) => false,
    );
  }

  void _signUp( BuildContext context ) async {
    final appModel = Provider.of<UserViewModel>(context, listen: false);

    final response = await appModel.signInWithEmailPassword(_emailController.text, _passwordController.text);

    if( response.status == ApiResponseStatus.COMPLETED ) {
      // _pushHomePage(context);
    } else if( response.status == ApiResponseStatus.ERROR ) {
      setState(() {
        _error = true;
        _message = response.message!;
      });
      final snackBar = SnackBar(content: Text('Could not sign in'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<UserViewModel>(context);
    final emailField = TextField(
      controller: _emailController,
      obscureText: false,
      style: style,
      enableInteractiveSelection: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
          )),
    );
    final passwordField = TextField(
      controller: _passwordController,
      obscureText: true,
      style: style,
      onSubmitted: (_) => _signUp(context),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('hamuwemu',
                    style: TextStyle(
                        fontFamily: 'Oleo Script',
                        fontSize: 48,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  appModel.status == ViewModelStatus.busy ?
                  LoadingLarge() :
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      RoundedButton(
                        onPressed: () => _signUp(context),
                        buttonLabel: ' Sign in ',
                        loading: false,
                      ),
                    ],
                  ),
                ],
              ),
            )
            ,
          ),
        ),
    );
  }
}

