import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/models/reservation.dart';
import 'package:provider/provider.dart';

import '../models/resident.dart';
import '../services/database.dart';

class addReservation extends StatefulWidget {
  const addReservation({Key? key}) : super(key: key);

  @override
  State<addReservation> createState() => _addReservationState();
}

class _addReservationState extends State<addReservation> {

  final _formkey = GlobalKey<FormState>();

  String resource = '';


  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  TimeOfDay temp = TimeOfDay.now();


  //add date and time
  @override
  Widget build(BuildContext context) {

    Resident curr_res = new Resident('', '', false, '', '');

    final residents = Provider.of<List<Resident>>(context);
    final user = Provider.of<User?>(context);
    final DatabaseService database = DatabaseService(user!.uid);

    //
    residents.forEach((res) {
      if (res.ID == user.uid){
        curr_res = res;
      }
    });
    database.initHouseName(curr_res.houseName);


    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Add Reservation'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child:
        Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              //resource
              TextFormField(
                decoration: InputDecoration(hintText: 'Resource'),
                onChanged: (val) {
                  resource = val;
                },
              ),
              SizedBox(height: 20.0,),
              //date
              ElevatedButton(
                onPressed: () async {
                  start = (await pickDate())!;
                  end = start;
                  if (start == null) return;
                },
                child: Text('Date ${start.month}/${start.day}/${start.year}')
              ),
              SizedBox(height: 20.0,),
              //start
              ElevatedButton(
                  onPressed: () async {
                    temp = (await pickTime())!;
                    start = new DateTime(start.year, start.month, start.day, temp.hour, temp.minute);
                    if (start == null) return;
                  },
                  child: Text('Start Time ${start.hour}:${start.minute}')
              ),
              SizedBox(height: 20.0,),
              //end
              ElevatedButton(
                  onPressed: () async {
                    temp = (await pickTime())!;
                    end = new DateTime(end.year, end.month, end.day, temp.hour, temp.minute);
                    if (end == null) return;
                  },
                  child: Text('End Time ${end.hour}:${end.minute}')
              ),
              SizedBox(height: 20.0,),
              //add button
              ElevatedButton(
                onPressed: () async{
                  //print("current user color: ${curr_res.color}");
                  Reservation newReservation = new Reservation(resource, start, end, user.uid, curr_res.name, curr_res.color);
                  await database.updateUserReservations(newReservation, curr_res.houseName);
                  Navigator.pop(context);
                },
                child: Text('Add Reservation')
              )
            ],
          )
        )
      )
    );
  }

  Future<DateTime?> pickDate(){
    return showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100)
    );
  }

  Future<TimeOfDay?> pickTime(){
    return showTimePicker(
        context: context,
        initialTime: temp
    );
  }
}
