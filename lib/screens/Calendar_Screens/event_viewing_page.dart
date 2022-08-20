

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/reservation.dart';

class EventViewingPage extends StatelessWidget{
  final event;

  EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final reservations = Provider.of<List<Reservation>>(context);

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          //buildDateTime(event),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.account_box_outlined, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: event.color,
            )
          ),
          SizedBox(height: 32),
          Text("Subject: ${event.subject}"),
          SizedBox(height: 32),
          Text("From: ${ DateFormat.yMMMMEEEEd().add_jm().format(event.startTime)}"),
          SizedBox(height: 32),
          Text("From: ${DateFormat.yMMMMEEEEd().add_jm().format(event.endTime)}"),
        ],

      ),
    );
  }
}