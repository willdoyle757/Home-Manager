import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/models/household.dart';
import 'package:home_manager/models/resident.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';

class home_new_house extends StatefulWidget {
  const home_new_house({Key? key}) : super(key: key);

  @override
  State<home_new_house> createState() => _home_new_houseState();
}

class _home_new_houseState extends State<home_new_house> {

  Resident curr_res = new Resident(" ", "ID", false, '', '');

  @override
  Widget build(BuildContext context) {

    String name = '';

    final residentsSnap = Provider.of<QuerySnapshot?>(context);
    final user = Provider.of<User?>(context);
    final DatabaseService database = DatabaseService(user!.uid);
    final residents = database.residentListFromSnapshot(residentsSnap!);
    final houses = Provider.of<List<household>?>(context);

    residents.forEach((resident) {
      if (resident.ID == user.uid){
        curr_res = resident;
      }
    });

    name = curr_res.name;

    return
    Center( child:
      Column(
        children: <Widget>[
          SizedBox(height: 75,),
          Text('Not Assigned to Any House', style: TextStyle(
            fontSize: 20,
            color: Colors.black,)
            ),
          SizedBox(height: 40,),
          ElevatedButton(
            //create house
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Provider(
                    create: (context) => residents,
                    builder: (context, child) => Provider(
                        create: (context) => name,
                        builder: (context, child) => createHouse()
                    )
                  )
                )
              );
            },
            child: Text('Create House')
          ),
          SizedBox(height: 40,),
          ElevatedButton(
            //join house
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Provider(
                    create: (context) => houses,
                    builder: (context, child) => Provider(
                        create: (context) => name,
                        builder: (context, child) =>joinHouse()
                    )
                  )
                )
              );
            },
            child: Text('Join House')
          ),
        ]
      )
    );
  }
}

//<----------------Create House ---------------->>

class createHouse extends StatefulWidget {
  const createHouse({Key? key}) : super(key: key);

  @override
  State<createHouse> createState() => _createHouseState();
}

class _createHouseState extends State<createHouse> {

  String houseName = '';
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final residents = Provider.of<List<Resident>>(context);
    final user = Provider.of<User?>(context);
    final name = Provider.of<String>(context);
    final DatabaseService database = DatabaseService(user!.uid);

    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Create New House'),
        ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child:
        Form(
          key: _formkey,
          child: Column(
            mainAxisSize : MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20.0,),
              //resource
              TextFormField(
                decoration: InputDecoration(hintText: 'House Name'),
                validator: (val) => val!.isEmpty && val == 'default' ? 'House must have a name' : null,
                onChanged: (val) {
                  houseName = val;
                },
              ),
              SizedBox(height: 20.0,),
              //end
              ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      database.updateUserData(name, true, houseName);
                      database.updateHouseData(houseName, '1111');
                      database.updateHouseUserData(houseName, name, '#000000');
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Create')
              ),
            ],
          )
        )
      )
    );
  }
}

//<-------------------Join House ----------------->

class joinHouse extends StatefulWidget {
  const joinHouse({Key? key}) : super(key: key);

  @override
  State<joinHouse> createState() => _joinHouseState();
}

class _joinHouseState extends State<joinHouse> {

  final _formkey = GlobalKey<FormState>();

  String houseName = '';
  String code = '';
  household tempHouse = household('', '');
  household house = household('', '');

  @override
  Widget build(BuildContext context) {

    final houses = Provider.of<List<household>>(context);
    final user = Provider.of<User?>(context);
    final name = Provider.of<String>(context);
    final DatabaseService database = DatabaseService(user!.uid);

    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Join House'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child:
            Form(
              key: _formkey,
              child: Column(
                mainAxisSize : MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  //resource
                  TextFormField(
                    decoration: InputDecoration(hintText: 'House'),
                    validator: (val) => val!.isEmpty ? 'House must have a name' : null,
                    onChanged: (val) {
                      houseName = val;

                      houses.forEach((h) {
                        if (h.name == houseName){
                          tempHouse = h;
                        }
                      });

                    },
                  ),
                  SizedBox(height: 20.0,),
                  //resource
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Code'),
                    validator: (val) => val?.length != 4 ? 'Code must be 4 digits long' : null,
                    onChanged: (val) {
                      code = val;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  //end
                  ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          if (tempHouse.code == code) {
                            house = tempHouse;
                            database.updateUserData(name, true, house.name);
                            database.updateHouseUserData(
                                house.name, name, '#000000');
                          }

                          Navigator.pop(context);
                        }
                      },
                      child: Text('Join')
                  ),
                ],
              )
            )
        )
    );
  }
}

