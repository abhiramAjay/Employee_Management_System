import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/services/databaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthServices _authServices = AuthServices();
  double screenWidth = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    // Validate form fields
    if (_formKey.currentState!.validate()) {
      try {
       final userResponse = await _authServices.createEmployeeWithEmailAndPassword(_nameController.text, _emailController.text, _passwordController.text);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
         content: Text("Employee registered successfully"),
       ));
       final String uid = userResponse.user.uid ?? "";
       Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        } else {
          print('Error registering user: ${e.message}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      
      body: Container(decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/img/clean.jpg'),
          fit: BoxFit.cover, // Fill the container with the image
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.only(top: 200,left: 20,right: 20),

          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Employee Signup", style: TextStyle(
                color: Colors.white,
                fontFamily: "NexaRegular",
                fontSize: 30,
                  fontWeight: FontWeight.bold
              )
              ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.white), // Set label text color to white
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white), // Set label text color to white
                    border: OutlineInputBorder(),
                  ),

                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white), // Set label text color to white
                    border: OutlineInputBorder(),
                  ),

                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: const Text('Register',style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize:  15,
                    color: Colors.white,
                    letterSpacing: 2,
                  )),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50), // Set minimum size for the button
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Color.fromARGB(255,57,66,145)// Increase font size of the text
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
