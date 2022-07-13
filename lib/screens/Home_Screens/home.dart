import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/screens/Home_Screens/home_appbar.dart';
import 'package:home_manager/services/auth.dart';
import 'package:home_manager/services/database.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService auth = AuthService();
  

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    
    return StreamProvider.value(
      value: DatabaseService(user!.uid).residents,
      initialData: null,
      child:StreamProvider.value(
        value: DatabaseService(user.uid).houses,
        initialData: null,
        child: Home_Appbar()
      )
    );
  }
}

