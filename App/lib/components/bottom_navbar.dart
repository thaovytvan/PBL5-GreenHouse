
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:green_garden/constants.dart';
import 'package:page_transition/page_transition.dart';

import '../ui/scan_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>{

  @override
  Widget build(BuildContext context) {
    int _bottomNavIndex = 0;
    List<IconData> iconList = [
      Icons.home,
      Icons.settings,
    ];
    return Scaffold(

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


    );
  }
}
