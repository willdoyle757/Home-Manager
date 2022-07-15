import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/screens/Home_Screens/home_appbar.dart';
import 'package:home_manager/services/auth.dart';
import 'package:home_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:home_manager/models/household.dart';
import '../../models/resident.dart';


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
    final DatabaseService database = DatabaseService(user!.uid);
    
    return StreamProvider.value(
      value: database.residents,
      initialData: null,
      child: StreamProvider.value(
        value: database.houses,
        initialData: null,
        child: const Home_Appbar()
      )
    );
  }
}

