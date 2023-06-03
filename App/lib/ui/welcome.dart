
import 'package:flutter/material.dart';
import 'package:green_garden/ui/home.dart';
import 'package:green_garden/ui/signin_page.dart';
import 'package:page_transition/page_transition.dart';

class  Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff43ea85),
              Color(0xff0b1e10),
            ],
            begin: Alignment.bottomLeft,
            end:  Alignment.topRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
          )
        ),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                bottom: 400,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Image.asset('assets/greenhouse.png', width: 75, height: 75),
                    const Padding(
                       padding: EdgeInsets.only(top: 10.0),
                       child:   Text('Green House', style: TextStyle(
                          fontSize: 29,
                          color: Colors.white,
                        ),)
                    )

                  ],
                ),
              ),
              Positioned(
                  bottom: 100,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: const SignIn(),
                                  type: PageTransitionType.bottomToTop));
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: const Center(
                            child: Text('Get Started', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            )),
                          ),
                        ),
                      ),

                  ))
            ],
          ),
        ),
      ),
      );
  }
}
