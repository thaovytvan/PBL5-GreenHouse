import 'package:flutter/material.dart';
import 'package:green_garden/components/custom_card.dart';
import 'package:green_garden/components/custom_card_auto.dart';
import 'package:green_garden/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';



class ControlTabBar extends StatefulWidget {
  const ControlTabBar({Key? key}) : super(key: key);

  @override
  State<ControlTabBar> createState() => _ControlTabBarState();
}


class _ControlTabBarState extends State<ControlTabBar> {
  bool _isAuto =false;
  final channel = IOWebSocketChannel.connect('ws://192.168.67.43:8080');
  String _light = "";
  String _pan = "";
  String _pump = "";

  bool _lightStatus = false;
  bool _pumpStatus = false;
  bool _panStatus = false;
  @override
  void initState() {
    channel.stream.listen((data) {
      try {
        final messageObj = json.decode(data);
        setState(() {
          _light = messageObj['bongden'].toString();
          _pan = messageObj['pan'].toString();
          _pump = messageObj['moto'].toString();
          _lightStatus = _light.toLowerCase() == 'true';
          _pumpStatus = _pump.toLowerCase() == 'true';
          _panStatus = _pan.toLowerCase() == 'true';
          print("den: $_lightStatus");
          print("FAN: $_lightStatus");
          print("moto: $_pumpStatus");
        });
      } catch (e) {
        print("Error: $e");
      }
    });
    super.initState();
  }
  Future<http.Response> createAlbum(String data) {
    return http.post(
      Uri.parse('http://192.168.67.43:3000/send-moto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'data': data,
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    right: 125,
                  ),
                  child: const Text(
                    'Device Control',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  'Auto',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_isAuto) {
                        createAlbum("0" );
                        _isAuto = false;
                      } else {
                        createAlbum("1" );
                        _isAuto = true;
                      }
                    });
                  },
                  child: Container(
                    width: 55,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _isAuto ? Colors.green : Colors.grey,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      _isAuto ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: _isAuto
                                ? const Icon(Icons.check,
                                color: Colors.green, key: ValueKey('on'))
                                : const Icon(Icons.close,
                                color: Colors.red, key: ValueKey('off')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          !_isAuto
              ? Column(
            children: [
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
          )
              : Column(
            children: [
              const SizedBox(height: 15),
              CustomCardAuto(
                size: size,
                icon: const ImageIcon(
                  AssetImage('assets/lights.png'),
                  size: 55,
                  color: Colors.white,
                ),
                title: "LIGHTS",
                statusOn: "ON",
                statusOff: "OFF",
                deviceStatus: _lightStatus,
              ),
              const SizedBox(height: 15),
              CustomCardAuto(
                size: size,
                icon: const ImageIcon(
                  AssetImage('assets/fan.png'),
                  size: 55,
                  color: Colors.white,
                ),
                title: "FAN",
                statusOn: "ON",
                statusOff: "OFF",
                deviceStatus: _panStatus,
              ),
              const SizedBox(height: 15),
              CustomCardAuto(
                size: size,
                icon: const ImageIcon(
                  AssetImage('assets/water_pump.png'),
                  size: 55,
                  color: Colors.white,
                ),
                title: "WATER PUMP",
                statusOn: "ON",
                statusOff: "OFF",
                deviceStatus: _pumpStatus,
              ),
            ],
          ),

],

      ),
      ),
    );
  }
}
