import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/services/auth.dart';
import 'package:home_manager/services/database.dart';
import 'package:home_manager/models/user.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Register'),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.white,
                ),
                onPressed: ()  {
                  widget.toggleView();
                },
                child: Text('Login')
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: PasswordRegister()
        )
    );
  }

  Widget PasswordRegister(){
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(hintText: 'Name'),
            validator: (val) => val!.isEmpty ? 'Enter a Name' : null,
            onChanged: (val) {
              name = val;
            },
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(hintText: 'Email'),
            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            onChanged: (val) {
              email = val;
            },
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(hintText: 'Password'),
            validator: (val) => val!.length < 6 ? 'Enter password greater than 6 letters' : null,
            obscureText: true,
            onChanged: (val) {
              password = val;
            },
          ),
          SizedBox(height: 20.0,),
          ElevatedButton(
              onPressed: () async{
                if (_formkey.currentState!.validate()){
                  print(email);
                  print(password);
                  dynamic result = await auth.registerWithEmail(email, password, name);
                  if(result == null){
                    error = 'please supply a valid email';
                  }
                }
              },
              child: Text('Register')
          )
        ],
      )
    );
  }

}
