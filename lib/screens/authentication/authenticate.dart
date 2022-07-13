import 'package:flutter/material.dart';
import 'package:home_manager/screens/authentication/login.dart';
import 'package:home_manager/screens/authentication/register.dart';



class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showLogin = true;

  toggleView(){
    setState(() {
      showLogin = !showLogin;
    });

  }

  @override
  Widget build(BuildContext context) {
    if (showLogin){
      return LoginPage(toggleView: toggleView);
    }
    else{
      return Register(toggleView: toggleView);
    }
  }
}