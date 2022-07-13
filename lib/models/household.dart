import 'package:home_manager/models/resident.dart';

class household {

  final String name;
  final String code;

  household(this.name, this.code);

  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'code' : code
    };
  }

}