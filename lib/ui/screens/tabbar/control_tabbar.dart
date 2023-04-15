import 'package:flutter/material.dart';
import 'package:green_garden/components/custom_card.dart';
import 'package:green_garden/constants.dart';
import 'package:web_socket_channel/io.dart';

class ControlTabBar extends StatefulWidget {
  const ControlTabBar({Key? key}) : super(key: key);

  @override
  State<ControlTabBar> createState() => _ControlTabBarState();
}

class _ControlTabBarState extends State<ControlTabBar> {
  bool _isAuto =true;
  late IOWebSocketChannel channel;
  bool connected=false; //boolean value to track if WebSocket is connected

  @override
  void initState() {
     //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.222.197:8080"); //channel IP : Port
      channel.stream.listen(
            (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message == "autoon:success") {
              _isAuto = true;
            } else if (message == "autooff:success") {
              _isAuto = false;
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (_isAuto == false && cmd != "autoon" && cmd != "autooff") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
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
                    right: 155,
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
                      // _isOn = !_isOn;
                      if (_isAuto) {
                        //if ledstatus is true, then turn off the led
                        //if led is on, turn off
                        sendcmd("autooff");
                        _isAuto = false;
                      } else {
                        //if ledstatus is false, then turn on the led
                        //if led is off, turn on
                        sendcmd("autoon");
                        _isAuto = true;
                      }
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 30,
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
