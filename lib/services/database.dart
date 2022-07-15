import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_manager/models/household.dart';
import 'package:home_manager/models/reservation.dart';
import 'package:home_manager/models/resident.dart';


class DatabaseService {

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference housesCollection = FirebaseFirestore.instance.collection('houses');

  //resident collection ---> housesCollection.doc(houseName).collection('resident')

  final String uid;
  late final String houseName;

  DatabaseService(this.uid);

  void initHouseName(String houseName){
    this.houseName = houseName;
  }

  Future deleteUser() async{
    housesCollection.doc(houseName).collection('residents').doc(uid).delete();
    return usersCollection.doc(uid).delete();
  }

  Future deleteHouse() async{
    return housesCollection.doc(houseName).delete();
  }

  Future updateUserData (String name, bool inHouse, String houseName) async {
    print('user updated');
    return await usersCollection.doc(uid).set({
      'name' : name,
      'inHouse' : inHouse,
      'houseName' : houseName
    });
  }

  Future updateHouseData (String houseName, String code) async{
    return await housesCollection.doc(houseName).set({
      'name' : houseName,
      'code' : code
    });
  }

  Future updateHouseUserData(String houseName, String name) async{
    return await housesCollection.doc(houseName).collection('residents').doc(uid).set({
      'name' : name,
      'inHouse' : true,
      'houseName' : houseName
    });
  }

  Future updateUserReservations(Reservation res, String houseName) async {
    await housesCollection.doc(houseName).collection('residents').doc(uid).collection('reservations').doc(res.resource.hashCode.toString()).set(
      res.toJson()
    );
  }

  List<Resident> residentListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot doc) {
      return Resident(
        doc.get('name') ?? ' ',
        doc.id,
        doc.get('inHouse') ?? false,
        doc.get('houseName')
      );
    }).toList();
  }

  Stream<QuerySnapshot> get residents {
    return usersCollection.snapshots();
        //.map(residentListFromSnapshot);
  }

  List<Reservation> reservationListFromSnapshot(QuerySnapshot snapshot){

    return snapshot.docs.map((DocumentSnapshot doc) {
      return Reservation(
        doc['resource'],
        doc['start'].toDate(),
        doc['end'].toDate()
      );
    }).toList();
  }


  Stream<List<Reservation>> get reservation {
    return housesCollection.doc(houseName).collection('residents').doc(uid).collection('reservations').snapshots().map(reservationListFromSnapshot);
  }

  List<household> householdFromSnapshot(QuerySnapshot snapshot){
    print('house request');
    return snapshot.docs.map((DocumentSnapshot doc) {
      print(doc['name']);
      return household(
          doc['name'],
          doc['code']
      );
    }).toList();
  }

  Stream<List<household>> get houses{
    return housesCollection.snapshots().map(householdFromSnapshot);
  }

  List<Resident> housematesFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot doc) {
      return Resident(
          doc.get('name') ?? ' ',
          doc.id,
          doc.get('inHouse'),
          doc.get('houseName')
      );
    }).toList();
  }

  Stream<List<Resident>> get housemates{
    return housesCollection.doc(houseName).collection('residents').snapshots().map(housematesFromSnapshot);
  }

}