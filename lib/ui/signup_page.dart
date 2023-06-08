import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_garden/constants.dart';
import 'package:green_garden/ui/home.dart';
import 'package:green_garden/ui/signin_page.dart';
import 'package:green_garden/ui/screens/widgets/custom_textfield.dart';


class SignUp extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email = '';
  String? fullName = '';
  String? password = '';

  SignUp({Key? key}) : super(key: key);


  Future<void> registerUser(BuildContext context, String? email, String? password, String? fullName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // Save additional user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName!,
        'email': email!,
        // Add more fields if needed
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } catch (e) {
      // Handle registration errors here
      print(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: SingleChildScrollView(
        child: Form(
          key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/signup.png'),
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              obscureText: false,
              hinText: 'Enter Email',
              icon: Icons.mail_outline,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Please Enter Your Email");
                }
                // reg expression for email validation
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please Enter a valid email");
                }
                return null;
              },
              onSaved: (value) {
                email = value; // Declare email as a String variable in the SignUp class
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              obscureText: false,
              hinText: 'Enter full name',
              icon: Icons.person,
              onSaved: (value) {
                fullName = value; // Declare fullName as a String variable in the SignUp class
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              obscureText: true,
              hinText: 'Enter Password',
              icon: Icons.lock,
              validator: (value) {
                RegExp regex = new RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return ("Password is required for login");
                }
                if (!regex.hasMatch(value)) {
                  return ("Enter Valid Password (Min. 6 Character)");
                }

              },
              onSaved: (value) {
                password = value; // Declare password as a String variable in the SignUp class
              },
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                final formState = _formKey.currentState;
                if (formState != null && formState.validate()) {
                  formState.save();
                  try {
                    await registerUser(context, email, password, fullName);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Registration Successful'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    // Registration failure message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Registration failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },


              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Constants.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset('assets/google.png'),
                  ),
                  Text(
                    'Sign Up with Google',
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  SignIn()),
                );
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Have an Account? ',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
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
