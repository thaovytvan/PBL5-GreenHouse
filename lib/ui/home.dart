import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:green_garden/constants.dart';
import 'package:green_garden/ui/scan_page.dart';
import 'package:green_garden/ui/screens/category/category_screen.dart';
import 'package:page_transition/page_transition.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
    State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  int _bottomNavIndex = 0;
  List<IconData> iconList = [
    Icons.home,
    Icons.settings,
  ];


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return SafeArea(
     child: Scaffold(
       appBar: AppBar(
         toolbarHeight: 170,
         title: Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('Home', style: TextStyle(
                   color: Constants.blackColor,
                   fontWeight: FontWeight.w500,
                   fontSize: 24,
                 ),),
                 Container(
                   decoration: BoxDecoration(
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.5),

                         offset: Offset(0, 3), // changes position of shadow
                       ),
                     ],
                     borderRadius: BorderRadius.circular(30),
                   ),
                   child: Icon(Icons.notifications, color: Constants.blackColor, size: 30.0,),

                 ),

               ],
             ),

             Padding(
               padding: const EdgeInsets.all(0.01),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     margin: const EdgeInsets.all(10.0),
                     child:
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row (
                             children:[
                               Image.asset(
                                 "assets/pin.png",
                                 width: 20,
                                 color: Colors.black,
                               ),
                               SizedBox(width: size.width * 0.02),
                               const Text(
                                 'Da Nang',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20.0,
                                 ),
                               ),
                             ]
                         ),
                         const Text(
                           'Hello, Michael',
                           style: TextStyle(
                             color: Colors.black87,
                             fontWeight: FontWeight.bold,
                             fontSize: 30,
                           ),
                         ),
                       ],
                     ),

                   ),
                   Container(
                     padding: const EdgeInsets.only(top: .5),
                     child:
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Container(
                           padding: const EdgeInsets.symmetric(
                             horizontal: 16.0,
                           ),
                           width: size.width * .9,
                           decoration: BoxDecoration(
                             color: Constants.primaryColor.withOpacity(.1),
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child:  Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(
                                 Icons.search,
                                 color: Colors.black54.withOpacity(.6),
                               ),
                               const Expanded(
                                   child: TextField(
                                     showCursor: false,
                                     decoration: InputDecoration(
                                       hintText: ' Search History',
                                       border: InputBorder.none,
                                       focusedBorder: InputBorder.none,
                                     ),
                                   )),
                               Icon(
                                 Icons.mic,
                                 color: Colors.black54.withOpacity(.6),
                               ),
                             ],
                           ),
                         )
                       ],
                     ),
                   ),



                 ],

               ),
             ),
           ],
         ),


         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
         elevation: 0.0,

       ),

      body:
          CategoryScreen(),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, PageTransition(child: const ScanPage(), type: PageTransitionType.bottomToTop));
        },
        backgroundColor: Constants.primaryColor,
        child: Image.asset('assets/code-scan-two.png', height: 30.0,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Constants.primaryColor,
        activeColor: Constants.primaryColor,
        inactiveColor: Colors.black.withOpacity(.5),
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index){
          setState(() {
            _bottomNavIndex = index;


          });

        },
      ),

    ),
    );
  }
}

