import 'package:flutter/material.dart';
import 'package:green_garden/components/custom_card.dart';
import 'package:green_garden/constants.dart';

class ControlTabBar extends StatefulWidget {
  const ControlTabBar({Key? key}) : super(key: key);

  @override
  State<ControlTabBar> createState() => _ControlTabBarState();
}
class _ControlTabBarState extends State<ControlTabBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
    child: Column(
    children: [
      const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.only(right: 250,),
          child: const Text(
            'Device Control',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
            ),
          ),
      ),
      const SizedBox(height: 15),

      const SizedBox(height: 15),
          CustomCard(
            size: size,
            icon: const ImageIcon(
              AssetImage('assets/lights.png'),
              size: 55,
              color: Colors.white,
            ),
            title: "LIGHTS",
            statusOn: "ON",
            statusOff: "OFF",
          ),
      const SizedBox(height: 15),
      CustomCard(
        size: size,
        icon: const ImageIcon(
          AssetImage('assets/fan.png'),
          size: 55,
          color: Colors.white,
        ),
        title: "FAN",
        statusOn: "ON",
        statusOff: "OFF",
      ),
      const SizedBox(height: 15),
      CustomCard(
        size: size,
        icon: const ImageIcon(
          AssetImage('assets/water_pump.png'),
          size: 55,
          color: Colors.white,
        ),
        title: "WATER PUMP",
        statusOn: "ON",
        statusOff: "OFF",
      ),
        ],
      ),
    ),

    );
  }
}
