import 'package:attendanceapp/services/databaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServices{
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseServices _databaseServices = DatabaseServices();

  Future createEmployeeWithEmailAndPassword(String name, String email, String password) async{
    try{
      final userResponse = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      debugPrint("User reponse: ${userResponse.user!.uid}");
      if(userResponse.user?.uid != null)
      {
        final databaseResponse = await _databaseServices.createEmployee(name, email, userResponse.user!.uid);
        debugPrint("database response: ${databaseResponse}");
      }
      return userResponse;
    }catch(e){
      debugPrint("Error while creation: ${e}");
      return null;
    }
  }

  Future signInEmployeeWithEmailAndPassword(String email, String password)async {
    try{
      final userResponse = await _auth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint("User response in login: ${userResponse.user}");
      return userResponse;
    }catch(e){
      debugPrint("Error while creation: ${e}");
      return null;
    }
  }
}