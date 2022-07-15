import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/screens/Home_Screens/home.dart';
import 'package:home_manager/screens/authentication/login.dart';
import '../services/auth.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';
import 'authentication/authenticate.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    print(user);
    if (user == null){
      return Authenticate();
    }
    else {
      return  HomePage();
    }
  }
}

/*
if (FirebaseAuth.instance.currentUser == null){
      return HomePage();
    }
    else{
      return Authenticate();
    }
 */