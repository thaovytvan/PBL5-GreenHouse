import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_garden/constants.dart';
import 'package:web_socket_channel/io.dart';
class CustomCardAuto extends StatefulWidget {
  const CustomCardAuto({
    Key? key,
    required this.size,
    required this.icon,
    required this.title,
    required this.statusOn,
    required this.statusOff,
    required this.deviceStatus, // Thêm thuộc tính deviceStatus
  }) : super(key: key);

  final Size size;
  final ImageIcon icon;
  final String title;
  final String statusOn;
  final String statusOff;
  final bool deviceStatus; // Khai báo thuộc tính deviceStatus

  @override
  _CustomCardAutoState createState() => _CustomCardAutoState();
}

class _CustomCardAutoState extends State<CustomCardAuto>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _animation;

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
                      child: Container(
                        height: 40,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade50,
                        ),
                        child: Align(
                          alignment: !widget.deviceStatus
                              ? Alignment.bottomCenter
                              : Alignment.topCenter,
                          child: Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 1),
                            decoration: BoxDecoration(
                              color: !widget.deviceStatus
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
              !widget.deviceStatus ? widget.statusOff : widget.statusOn,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: !widget.deviceStatus ? Colors.white : kGreenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
