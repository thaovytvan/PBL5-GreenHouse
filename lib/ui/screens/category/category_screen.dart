import 'package:flutter/material.dart';
import 'package:green_garden/constants.dart';
import 'package:green_garden/ui/screens/tabbar/control_tabbar.dart';
import 'package:green_garden/ui/screens/tabbar/overview_tabbar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State <CategoryScreen>{
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Overview'),
    const Tab(text: 'Control'),
    const Tab(text: 'Plant'),
    const Tab(text: 'Pest and Disease'),
    const Tab(text: 'Camera'),
  ];

  final List<Widget> myTabViews = <Widget>[
    Container(child: const OverviewTabBar()),
    Container(child: const ControlTabBar()),
    Container(child: const Text('Plant History')),
    Container(child: const Text('Pest and Disease History')),
    Container(child: const Text('Camera')),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 2,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom:
          TabBar(
            labelColor: Constants.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: myTabs,
            isScrollable: true,

          ),
        ),
        body: TabBarView(
          children:
          myTabViews,
        ),
      ),
    );
  }
}

  
