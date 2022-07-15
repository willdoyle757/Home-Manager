import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/models/household.dart';
import 'package:provider/provider.dart';

import '../models/resident.dart';
import '../services/auth.dart';
import '../services/database.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({Key? key}) : super(key: key);

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  Widget build(BuildContext context) {

    Resident curr_res = new Resident('', '', false, '');


    final user = Provider.of<User?>(context);
    final email = user!.email;
    final password = '';
    final DatabaseService database = DatabaseService(user.uid);

    final house = Provider.of<household>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Settings',
          style: TextStyle(
            color: Colors.white
          ),
        )
      ),
      body: Column(
        children: [
          SizedBox(height: 30),

          Center(
            child: Text(
              'Home Code: ${house.code}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25
              ),
            )
          ),

          SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async {
              //await AuthService().deleteUser(email!, password);
            },
            child: Text('delete account'),
          ),

          SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async {
              /*QuerySnapshot col_ref = await database.housesCollection.doc(house.name).collection("residents").get();

              List<DocumentSnapshot> documents = col_ref.docs;
              documents.forEach((data) =>  database.usersCollection.doc(data.id).set({
                'inHouse' : false,
                'houseName' : ''
              }));
              await database.deleteHouse();*/
            },
            child: Text('delete house'),
          )

        ],
      ),
    );
  }
}
