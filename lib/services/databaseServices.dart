import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseServices{
  final CollectionReference employeesCollection = FirebaseFirestore.instance.collection("employees");

  createEmployee(String name, String email, String uid)async{
    try{
      return await employeesCollection.doc(uid).set(
          {
            "name": name,
            "email": email
          }
      );
    }catch(e){
      debugPrint("Exception while adding to databse: $e");
    }
  }

  Future getTodaysAttendanceOfAnEmployee(
      String employeeUid, String attendanceDocId) async {
    try {
      return await employeesCollection.doc(employeeUid).collection("Record").doc(attendanceDocId).get();
    } catch (e) {
      debugPrint("Error while fetching employee todays attendance: $e");
      return null;
    }
  }
}
