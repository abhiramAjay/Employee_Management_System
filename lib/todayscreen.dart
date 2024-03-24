import 'dart:async';
import 'package:attendanceapp/model/user.dart';
import 'package:attendanceapp/services/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = " ";
  String scanResult = " ";
  String officeCode = " ";

  Color primary = const Color.fromARGB(255,57,66,145);
  late SharedPreferences sharedPreferences;


  @override
  void initState() {
    super.initState();
    _getRecord();
    // _getOfficeCode();

  }

  // void _getOfficeCode() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance.collection("Attributes").doc("Office1").get();
  //   setState(() {
  //     officeCode = snap['code'];
  //   });
  // }


  void _getLocation() async {
    List<Placemark> placemark = await placemarkFromCoordinates(User.lat, User.long);

    setState(() {
      location = "${placemark[0].street}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}";
    });
  }

  void _getRecord() async {
    final String employeeUid = await HelperFunctions.getUserUidFromSharedPreference();
    try {


      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("employees")
          .doc(employeeUid)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();


      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch(e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/img/clean.jpg'),
          fit: BoxFit.cover, // Fill the container with the image
        ),
      ),
        height: screenHeight,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "Welcome,",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Employee Test"  ,
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "Today's Status",
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 32),
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
                            checkIn,
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
                            checkOut,
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
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                      color: primary,
                      fontSize: screenWidth / 18,
                      fontFamily: "NexaBold",
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 20,
                          fontFamily: "NexaBold",
                        ),
                      ),
                    ],
                  ),
                )
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
              checkOut == "--/--" ? Container(
                margin: const EdgeInsets.only(top: 24, bottom: 12),
                child: Builder(
                  builder: (context) {
                    final GlobalKey<SlideActionState> key = GlobalKey();

                    return SlideAction(
                      text: checkIn == "--/--" ? "Slide to Check In" : "Slide to Check Out",
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaRegular",
                      ),
                      outerColor: Color.fromARGB(255,206,165,225),
                      innerColor: primary,
                      key: key,
                      onSubmit: () async {
                        final String employeeUid = await HelperFunctions.getUserUidFromSharedPreference();


                        if(User.lat != 0) {
                          _getLocation();

                          DocumentSnapshot snap2 = await FirebaseFirestore.instance
                              .collection("employees")
                              .doc(employeeUid)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                              .get();

                          try {
                            String checkIn = snap2['checkIn'];

                            setState(() {
                              checkOut = DateFormat('hh:mm').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance
                                .collection("employees")
                                .doc(employeeUid)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                .update({
                              'date': Timestamp.now(),
                              'checkIn': checkIn,
                              'checkOut': DateFormat('hh:mm').format(DateTime.now()),
                              'checkInLocation': location,
                            });
                          } catch (e) {
                            setState(() {
                              checkIn = DateFormat('hh:mm').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance
                                .collection("employees")
                                .doc(employeeUid)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                .set({
                              'date': Timestamp.now(),
                              'checkIn': DateFormat('hh:mm').format(DateTime.now()),
                              'checkOut': "--/--",
                              'checkOutLocation': location,
                            });
                          }

                          key.currentState!.reset();
                        } else {
                          Timer(const Duration(seconds: 3), () async {
                            _getLocation();

                            DocumentSnapshot snap2 = await FirebaseFirestore.instance
                                .collection("employees")
                                .doc(employeeUid)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                .get();

                            try {
                              String checkIn = snap2['checkIn'];

                              setState(() {
                                checkOut = DateFormat('hh:mm').format(DateTime.now());
                              });

                              await FirebaseFirestore.instance
                                  .collection("employees")
                                  .doc(employeeUid)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                  .update({
                                'date': Timestamp.now(),
                                'checkIn': checkIn,
                                'checkOut': DateFormat('hh:mm').format(DateTime.now()),
                                'checkInLocation': location,
                              });
                            } catch (e) {
                              setState(() {
                                checkIn = DateFormat('hh:mm').format(DateTime.now());
                              });

                              await FirebaseFirestore.instance
                                  .collection("employees")
                                  .doc(employeeUid)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                  .set({
                                'date': Timestamp.now(),
                                'checkIn': DateFormat('hh:mm').format(DateTime.now()),
                                'checkOut': "--/--",
                                'checkOutLocation': location,
                              });
                            }

                            key.currentState!.reset();
                          });
                        }
                      },
                    );
                  },
                ),
              ) : Container(
                margin: const EdgeInsets.only(top: 32, bottom: 32),
                child: Text(
                  "You have completed this day!",
                  style: TextStyle(
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 20,
                    color: Colors.black54,
                  ),
                ),
              ),
              location != " " ? Text(
                "Location: " + location,
              ) : const SizedBox(),

            ],
          ),
        ),
      )
    );
  }
}
