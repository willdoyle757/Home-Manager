import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/reservation.dart';
import '../../models/resident.dart';
import '../../services/auth.dart';

class home_dash extends StatefulWidget {
  const home_dash({Key? key}) : super(key: key);

  @override
  State<home_dash> createState() => _home_dashState();
}

class _home_dashState extends State<home_dash> {

  @override
  Widget build(BuildContext context) {

    Resident curr_res = new Resident('', '', false, '');

    final residentsSnap = Provider.of<QuerySnapshot>(context);
    final user = Provider.of<User?>(context);
    final DatabaseService database = DatabaseService(user!.uid);
    final residents = database.residentListFromSnapshot(residentsSnap);
    final housemates = Provider.of<List<Resident>>(context);
    final reservations = Provider.of<List<Reservation>?>(context);



    residents.forEach((res) {
      if (res.ID == user.uid){
        curr_res = res;
      }
    });

    database.initHouseName(curr_res.houseName);

    //print(reservations);
    if (reservations!.length == 0){
      return noRes(curr_res, housemates);
    }

    return
      Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 30.0,),
          //title
          Center(
            child: Text('Reservations',
              style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              ),
            ),
          ),
          //reservation list
          reservationList(reservations, curr_res.name),

          SizedBox(height: 30.0,),

          Center(
            child: Text('${curr_res.houseName} Residents',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),

          houseResidentsList(housemates)
        ]
      )
    );
  }

  Widget noRes(Resident curr_res, List housemates){
    return Container(
      child:
      Column(
        children: <Widget>[
          SizedBox(height: 30.0,),
      //title
          Center(
            child: Text('Reservations',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 30.0,),
          Center(
            child: Text('You currently have no reservations',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 30.0,),

          Center(
            child: Text('${curr_res.houseName} Residents',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),

          houseResidentsList(housemates)
        ],
      )
    );
  }

  Widget reservationList(List reservations, String curr_res_name){

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: reservations.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (BuildContext context, index) {
        return Card (child: ListTile(
          leading: Text( '${reservations[index].resource}'),
          title: Text(' ${reservations[index].start}'),
          trailing: Text(curr_res_name),
        )
        );
      },
    );
  }

  Widget houseResidentsList(List houseResidents){
    return ListView.builder(scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: houseResidents.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (BuildContext context, index) {
        return Card (child: ListTile(
          title: Text(' ${houseResidents[index].name}'),
          )
        );
      },
    );
  }
}
