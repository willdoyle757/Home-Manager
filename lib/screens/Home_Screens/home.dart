import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/screens/Home_Screens/home_appbar.dart';
import 'package:home_manager/services/auth.dart';
import 'package:home_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:home_manager/models/household.dart';
import '../../models/reservation.dart';
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
        child: home_Wrapper()
      )
    );
  }
}

class home_Wrapper extends StatefulWidget {
  const home_Wrapper({Key? key}) : super(key: key);

  @override
  State<home_Wrapper> createState() => _home_WrapperState();
}

class _home_WrapperState extends State<home_Wrapper> {
  @override
  Widget build(BuildContext context) {

    //household house = new household('', '');
    Resident curr_res = new Resident(" ", "ID", false, '', '');

    final residentsSnap = Provider.of<QuerySnapshot>(context);
    final user = Provider.of<User?>(context);
    final DatabaseService database = DatabaseService(user!.uid);
    final residents = database.residentListFromSnapshot(residentsSnap);
    final houses = Provider.of<List<household>>(context);

    residents.forEach((res) {
      if (res.ID == user.uid){
        curr_res = res;
      }
    });


    database.initHouseName(curr_res.houseName);

    return StreamProvider.value(
      value: database.housemates,
      initialData: null,
      child: StreamProvider.value(
        value: database.reservation,
        initialData: null,
        child:Home_Appbar()
      )
    );
  }
}


