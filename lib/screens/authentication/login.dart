import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_manager/models/user.dart';
import 'package:home_manager/screens/loading.dart';

import '../../services/auth.dart';

class LoginPage extends StatefulWidget {

  final Function toggleView;
  LoginPage({required this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final AuthService auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;

  late String userName;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingScreen() : Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Sign in to Home Manager'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.white,
            ),
            onPressed: ()  {
              widget.toggleView();
            },
            child: Text('Register')
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: PasswordLogin()
      )
    );
  }

  Widget PasswordLogin(){
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
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
            validator: (val) => val!.length < 6 ? 'Enter valid password' : null,
            obscureText: true,
            onChanged: (val) {
              password = val;
            },
          ),
          SizedBox(height: 20.0,),
          ElevatedButton(
              onPressed: () async{
                if (_formkey.currentState!.validate()){
                  //setState(() => loading = true);
                  print(email);
                  print(password);
                  dynamic result = await auth.loginWithEmail(email, password);
                  if(result == null){
                    setState(() {
                      error = 'Wrong email or password';
                      //loading = false;
                    });
                  }
                  else{
                    setState(() {
                      //loading = false;
                    });
                  }
                }
              },
              child: Text('Sign In')
          )
        ],
      )
    );
  }

  Widget NameTextField(){
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter Name',
      ),
      onChanged: (text) {
        userName = text;
      },
    );
  }

}


