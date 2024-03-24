import 'dart:async';

import 'package:attendanceapp/model/user.dart';
import 'package:attendanceapp/services/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  String employeeUid = "";

  Color primary = const Color.fromARGB(255,57,66,145);
  late SharedPreferences sharedPreferences;


  String _month = DateFormat('MMMM').format(DateTime.now());
  void initState() {
    super.initState();
    _getEmployeeUid(); // Call the function to get the UID
  }

  void _getEmployeeUid() async {
    employeeUid = await HelperFunctions.getUserUidFromSharedPreference();
    setState(() {}); // Rebuild the widget tree with the updated employeeUid
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/img/clean.jpg'),
          fit: BoxFit.fill, // Fill the container with the image
        ),
      ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32,bottom: 32),
                child: Text(
                  "My Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 15,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 32),
                    child: Text(
                      _month,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 32),
                    child: GestureDetector(
                      onTap: () async {
                        final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2099),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primary,
                                  secondary: primary,
                                  onSecondary: Color.fromARGB(255,206,165,225),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: primary,
                                  ),
                                ),
                                textTheme: const TextTheme(
                                  headline4: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  overline: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  button: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          }
                        );

                        if(month != null) {
                          setState(() {
                            _month = DateFormat('MMMM').format(month);
                          });
                        }
                      },
                      child: Text(
                        "Pick a Month",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 1.45,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("employees")
                      .doc(employeeUid)
                      .collection("Record")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          return DateFormat('MMMM').format(snap[index]['date'].toDate()) == _month ? Container(
                            margin: EdgeInsets.only(top: index > 0 ? 12 : 0, left: 6, right: 6),
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255,206,165,225),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(2, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(),
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        DateFormat('EE\ndd').format(snap[index]['date'].toDate()),
                                        style: TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: screenWidth / 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Check In",
                                        style: TextStyle(
                                          fontFamily: "NexaRegular",
                                          fontSize: screenWidth / 20,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        snap[index]['checkIn'],
                                        style: TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: screenWidth / 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Check Out",
                                        style: TextStyle(
                                          fontFamily: "NexaRegular",
                                          fontSize: screenWidth / 20,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        snap[index]['checkOut'],
                                        style: TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: screenWidth / 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(height:500,color: Color.fromARGB(255, 27,40,93),);
                        },
                      );
                    } else {
                      return  Container(height:100,color: Color.fromARGB(255, 27,40,93),);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
