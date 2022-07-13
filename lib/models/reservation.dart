import 'package:flutter/material.dart';
import 'package:home_manager/models/resident.dart';
import 'package:home_manager/models/resource.dart';

class Reservation{

 final String resource;
 final DateTime start;
 final DateTime end;


 Reservation (this.resource, this.start, this.end);

 Map<String, dynamic> toJson(){
  return {
   'resource' : resource,
   'start' : start,
   'end' : end
  };
 }

}