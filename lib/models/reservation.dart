import 'package:flutter/material.dart';
import 'package:home_manager/models/resident.dart';
import 'package:home_manager/models/resource.dart';

class Reservation{

 final String resource;
 final DateTime start;
 final DateTime end;
 final String userid;
 final String username;
 final String color;


 Reservation (this.resource, this.start, this.end, this.userid, this.username, this.color);

 Map<String, dynamic> toJson(){
  return {
   'resource' : resource,
   'start' : start,
   'end' : end,
   'userid' : userid,
   'username' : username,
   'color' : color
  };
 }

}