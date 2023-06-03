
import 'package:flutter/material.dart';
import 'package:green_garden/constants.dart';
import 'package:green_garden/ui/home.dart';
import 'package:green_garden/ui/screens/widgets/custom_textfield.dart';
import 'package:green_garden/ui/signin_page.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
              height: 30,
            ),
             CustomTextField(
              obscureText: false,
              hinText: 'Enter Email',
              icon: Icons.mail_outline,

            ),
            CustomTextField(
              obscureText: false,
              hinText: 'Enter full name',
              icon: Icons.person,

            ),
            CustomTextField(
              obscureText: true,
              hinText: 'Enter Password',
              icon: Icons.lock,

            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              // onTap: () {
              //   Navigator.pushReplacement(
              //       context,
              //       PageTransition(
              //           child: const RootPage(),
              //           type: PageTransitionType.bottomToTop));
              // },
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
              },
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
              height: 10,
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
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset('assets/google.png'),
                  ),
                  Text('Sign Up with Google',
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 18.0,
                      ))
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
                    PageTransition(
                        child: const SignIn(),
                        type: PageTransitionType.bottomToTop));
              },

              child: Center(
                child: Text.rich(TextSpan(children: [
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
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
