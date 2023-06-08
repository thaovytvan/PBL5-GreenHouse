import 'package:flutter/material.dart';
import 'package:green_garden/constants.dart';
import 'package:green_garden/ui/screens/tabbar/control_tabbar.dart';
import 'package:green_garden/ui/screens/tabbar/overview_tabbar.dart';
import 'package:green_garden/ui/screens/tabbar/device_history_tabbar.dart';
import 'package:green_garden/ui/screens/tabbar/disease_history_tabbar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Overview'),
    const Tab(text: 'Control'),
    const Tab(text: 'Device'),
    const Tab(text: 'Pest and Disease'),
    const Tab(text: 'Camera'),
  ];

  final List<Widget> myTabViews = <Widget>[
    OverviewTabBar(),
    ControlTabBar(),
    DeviceHistoryWidget(),
    DiseaseHistoryWidget(),
    const Text('Camera'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          labelColor: Constants.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: myTabs,
          controller: _tabController,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabViews.map((widget) {
          return KeepAliveWrapper(widget);
        }).toList(),
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper(this.child);

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
