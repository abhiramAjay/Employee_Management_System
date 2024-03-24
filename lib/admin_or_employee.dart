import 'package:flutter/material.dart';

import 'adminlogin.dart';
import 'loginscreen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Maintain transparency for background image
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/img/snow.jpg'),
            fit: BoxFit.cover, // Fill the container with the image
          ),
        ),
        child: Center(
          // Wrap Column with Padding for top and bottom spacing
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoginButton('Admin', () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AdminLogin()));
                }),
                const SizedBox(height: 20),
                _buildLoginButton('Employee', () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => EmpolyeeLogin()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24.0,
          fontFamily: 'NexaBold', // Use NexaBold font
          color: Colors.white, // Adjust text color for better contrast on background
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(220,57,66,145), // Adjust button color as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        ),
        minimumSize: const Size(200, 50), // Set button size
      ),
    );
  }
}
