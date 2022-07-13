
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:home_manager/models/user.dart';
import 'package:home_manager/services/database.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;



  User_Mod? firebaseUser(User user){
    return user != null ? User_Mod(user.uid, 'default') : null;
  }

  Stream<User?> get user {
    return auth.userChanges();
  }

  //register with email and password
  Future registerWithEmail(String email, String password, String name) async{
    try{
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      DatabaseService(user!.uid).updateUserData(name , false, 'default');

      return firebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future loginWithEmail(String email, String password) async{
    try{
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return firebaseUser(user!);
    }
    catch(e){
      print(e.toString());
    }
  }
  //login with email


  Future signOut() async {
    try {
      return await auth.signOut();
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

}