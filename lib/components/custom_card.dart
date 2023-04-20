import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_garden/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// Khởi tạo kết nối tới Firebase Realtime Database
final databaseReference = FirebaseDatabase.instance.reference();


class CustomCard extends StatefulWidget {
  const CustomCard(
      {Key? key,
        required this.size,
        required this.icon,
        required this.title,
        required this.statusOn,
        required this.statusOff})
      : super(key: key);

  final Size size;
  final ImageIcon icon;
  final String title;
  final String statusOn;
  final String statusOff;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _animation;

  // esp8266
  bool isChecked = false ;
   //boolean value to track device status, if its ON or OFF
  late IOWebSocketChannel channel;
  bool connected = false; //boolean value to track if WebSocket is connected

  @override
  void initState() {
    // connect esp8266
    //
    // Future.delayed(Duration.zero, () async {
    //   channelconnect(); //connect to WebSocket wth NodeMCU
    // });

    // code mobile
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _animation = Tween<Alignment>(
        begin: Alignment.bottomCenter, end: Alignment.topCenter)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
        reverseCurve: Curves.easeInBack,
      ),
    );
    super.initState();
  }

  // esp8266 connect function
  // channelconnect() {
  //   //function to connect
  //   try {
  //     channel =
  //         IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
  //     channel.stream.listen(
  //           (message) {
  //         print(message);
  //         setState(() {
  //           if (message == "connected") {
  //             connected = true; //message is "connected" from NodeMCU
  //           } else if (message == "${widget.title}on:success") {
  //             isChecked = true;
  //           } else if (message == "${widget.title}off:success") {
  //             isChecked = false;
  //           }
  //         });
  //       },
  //       onDone: () {
  //         //if WebSocket is disconnected
  //         print("Web socket is closed");
  //         setState(() {
  //           connected = false;
  //         });
  //       },
  //       onError: (error) {
  //         print(error.toString());
  //       },
  //     );
  //   } catch (_) {
  //     print("error on connecting to websocket.");
  //   }
  // }
  //
  // Future<void> sendcmd(String cmd) async {
  //   if (connected == true) {
  //     if (isChecked == false && cmd != "${widget.title}on" && cmd != "${widget.title}off") {
  //       print("Send the valid command");
  //     } else {
  //       channel.sink.add(cmd); //sending Command to NodeMCU
  //     }
  //   } else {
  //     channelconnect();
  //     print("Websocket is not connected.");
  //   }
  // }
  Future<http.Response> createAlbum(String data, String title) {

    return http.post(
      Uri.parse('http://192.168.152.80:3000/send-moto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': data,
        'title': title,
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.16,
      width: widget.size.width * 0.9,
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(.75),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(3, 3),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 0,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.icon,
                widget.title != "LEAKS"
                    ? AnimatedBuilder(
                  animation: _animationController,
                  builder: (animation, child) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _animationController.animateTo(0);
                          if (_animationController.isCompleted ) {
                            _animationController.animateTo(20);
                          } else {
                            _animationController.animateTo(0);
                          }
                          if (isChecked) {
                            createAlbum("0","${widget.title}" );
                            // sendMoto();
                            //if ledstatus is true, then turn off the led
                            //if led is on, turn off
                            // sendcmd("${widget.title}off");
                            isChecked = false;
                          } else {
                            //if ledstatus is false, then turn on the led
                            //if led is off, turn on
                            createAlbum("1", "${widget.title}");
                            // sendMoto();
                            // sendcmd("${widget.title}on");
                            isChecked = true;
                          }

                        });
                      },
                      child: Container(
                        height: 40,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade50,

                        ),
                        child: Align(
                          alignment: _animation.value,
                          child: Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 1),
                            decoration: BoxDecoration(
                              color: !isChecked
                                  ? Colors.black54
                                  : kGreenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : Container(),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              !isChecked ? widget.statusOff : widget.statusOn,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: !isChecked ? Colors.white : kGreenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}