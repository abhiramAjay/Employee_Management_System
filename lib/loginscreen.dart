import 'package:attendanceapp/homescreen.dart';
import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/services/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpolyeeLogin extends StatefulWidget {
  const EmpolyeeLogin({Key? key}) : super(key: key);

  @override
  _EmpolyeeLoginState createState() => _EmpolyeeLoginState();
}

class _EmpolyeeLoginState extends State<EmpolyeeLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  AuthServices _authServices = AuthServices();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromARGB(255,57,66,145);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/img/dark.jpg'),
              fit: BoxFit.cover, // Fill the container with the image
            ),
          ),
          child: Column(
            children: [
               Container(
                height: screenHeight / 3.7,
                width: screenWidth,
                // decoration: BoxDecoration(
                //   color: primary,
                  // borderRadius: const BorderRadius.only(
                  //   bottomRight: Radius.circular(70),
                  // ),
                // ),
                // child: Center(
                //   child: Icon(
                //     Icons.person,
                //     color: Colors.white,
                //     size: screenWidth / 5,
                //   ),
                // ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: screenHeight / 15,
                  bottom: screenHeight / 20,
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: screenWidth / 18,
                    fontFamily: "NexaBold",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth / 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldTitle("Employee ID"),
                    customField("Enter your employee id", emailController, false),
                    fieldTitle("Password"),
                    customField("Enter your password", passController, true),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String id = emailController.text.trim();
                        String password = passController.text.trim();

                        if(id.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Employee id is still empty!"),
                          ));
                        } else if(password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Password is still empty!"),
                          ));
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Employee").where('id', isEqualTo: id).get();

                          try {
                            // final result = await _authServices.createEmployeeWithEmailAndPassword(emailController.text, passController.text);
                            final result = await _authServices.signInEmployeeWithEmailAndPassword(emailController.text, passController.text);
                            if(result!=null){
                              HelperFunctions.setUserUidToSharedPreference(result.user.uid).then((_) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => HomeScreen())
                                );
                              });
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Invalid credentials"),
                              ));
                            }
                            // if(password == snap.docs[0]['password']) {
                            //   sharedPreferences = await SharedPreferences.getInstance();
                            //
                            //
                            //   sharedPreferences.setString('employeeId', id).then((_) {
                            //     Navigator.pushReplacement(context,
                            //         MaterialPageRoute(builder: (context) => HomeScreen())
                            //     );
                            //   });
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            //     content: Text("Password is not correct!"),
                            //   ));
                            // }
                          } catch(e) {
                            debugPrint("Error in catch: ${e}");
                            String error = " ";

                            if(e.toString() == "RangeError (index): Invalid value: Valid value range is empty: 0") {
                              setState(() {
                                error = "Employee id does not exist!";
                              });
                            } else {
                              setState(() {
                                error = "Error occurred!";
                              });
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(error),
                            ));
                          }
                        }
                      },
                      child: Container(
                        height: 60,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: screenHeight / 40),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 26,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: screenWidth,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to signup page (replace with your navigation logic)
                        Navigator.pushNamed(context, '/Signup'); // Assuming signup page route is named '/signup'
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: screenWidth / 26,
                          fontFamily: "NexaBold",
                          color: primary,
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: screenWidth,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }

  Widget customField(String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          )
        ],
      ),
    );
  }

}
