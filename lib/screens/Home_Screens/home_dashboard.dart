import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/screens/loading.dart';
import 'package:home_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../models/reservation.dart';
import '../../models/resident.dart';
import '../../services/auth.dart';

class home_dash extends StatefulWidget {
  const home_dash({Key? key}) : super(key: key);

  @override
  State<home_dash> createState() => _home_dashState();
}

class _home_dashState extends State<home_dash> {
  Color color = Colors.black45;
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    Resident curr_res = new Resident('', '', false, '', '');

    final residentsSnap = Provider.of<QuerySnapshot?>(context);
    final user = Provider.of<User?>(context);
    final DatabaseService database = DatabaseService(user!.uid);
    final residents = database.residentListFromSnapshot(residentsSnap!);
    final housemates = Provider.of<List<Resident>?>(context);
    final reservations = Provider.of<List<Reservation>?>(context);

    residents.forEach((res) {
      if (res.ID == user.uid){
        curr_res = res;
      }
    });

    database.initHouseName(curr_res.houseName);

    if (user == null || housemates == null || reservations == null){
      loading = true;
    }
    else {
      loading = false;
    }
    //print(reservations);
    if (reservations!.length == 0){
      return noRes(curr_res, housemates!);
    }

    return
      loading ? LoadingScreen() : Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 30.0,),
          //title
          const Center(
            child: Text('Reservations',
              style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              ),
            ),
          ),
          //reservation list
          reservationList(reservations, curr_res.name, residents),

          SizedBox(height: 30.0,),

          Center(
            child: Text('${curr_res.houseName} Residents',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),

          houseResidentsList(housemates!)
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

  Resident residentSearch(List<Resident> residents, String id)
  {
    Resident res = new Resident('name', 'ID', false, 'houseName', '');
    residents.forEach((temp) {
      if (temp.ID == id){
        res = temp;
      }
    });

    return res;
  }

  Widget reservationList(List reservations, String curr_res_name, List<Resident> residents){

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: reservations.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (BuildContext context, index) {
        return Card (child: ListTile(
          leading: Text( '${reservations[index].resource}'),
          title: Text(' ${reservations[index].start}'),
          trailing: Text('${residentSearch(residents, reservations[index].userid).name}'),
        )
        );
      },
    );
  }

  Color hexToColor(String code) {
    //print(code);
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /*Widget buildColorPicker() => ColorPicker(
    pickerColor: color,
  )*/

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick profile color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextButton(
              onPressed: () {Navigator.of(context).pop();},
              child: Text(
                'SELECT',
                style: TextStyle(fontSize: 20),
              )
            )
          ],
        ),
      )
  );
  
  Widget houseResidentsList(List houseResidents){
    return ListView.builder(scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: houseResidents.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (BuildContext context, index) {
        return Card (child: ListTile(
          leading: ElevatedButton(
            onPressed: () {
              pickColor(context);
            },
            child: Icon(Icons.account_box_outlined, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: hexToColor(houseResidents[index].color), // <-- Button color
            ),
          ),
          title: Text(' ${houseResidents[index].name}'),
          )
        );
      },
    );
  }
}
