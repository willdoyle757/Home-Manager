import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_manager/models/reservation.dart';
import 'package:home_manager/screens/Home_Screens/home_dashboard.dart';
import 'package:home_manager/screens/Home_Screens/home_new_house.dart';
import 'package:home_manager/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/resident.dart';
import '../../services/auth.dart';
import '../add_reservation.dart';

class Home_Appbar extends StatefulWidget {
  const Home_Appbar({Key? key}) : super(key: key);

  @override
  State<Home_Appbar> createState() => _Home_AppbarState();
}

class _Home_AppbarState extends State<Home_Appbar> {

  final AuthService auth = AuthService();
  Resident curr_res = new Resident(" ", "ID", false, '');

  @override
  Widget build(BuildContext context) {

    String name = '';


    final residentsSnap = Provider.of<QuerySnapshot>(context);
    final user = Provider.of<User?>(context);
    final DatabaseService database = DatabaseService(user!.uid);
    final residents = database.residentListFromSnapshot(residentsSnap);

    residents.forEach((resident) {
      if (resident.ID == user.uid){
        curr_res = resident;
      }
    });

    name = curr_res.name;

    database.initHouseName(curr_res.houseName);

    return
      StreamProvider.value(
        value: database.reservation,
        initialData: null,
        child: Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,

        title: Text('Hello, ' + name),
        actions: <Widget>[
          TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                primary: Colors.white,
              ),
              onPressed: () async {
                await auth.signOut();
              },
              child: Text('Logout')
          )
        ]
      ),
      drawer: Drawer(

      ),
      body: HomeBody(),
      floatingActionButton: (curr_res.inHouse) ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Provider(
                create: (context) => residents,
                builder: (context, child) => addReservation()
              )
            )
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ) : null
        )
    );
  }

  Widget HomeBody(){
    if (curr_res.inHouse == true){
      return home_dash();
    }
    else {
      return home_new_house();
    }
  }

}

