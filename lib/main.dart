import 'package:flutter/material.dart';
import 'package:home_manager/screens/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:home_manager/screens/wrapper.dart';
import 'package:home_manager/services/auth.dart';
import 'package:provider/provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
