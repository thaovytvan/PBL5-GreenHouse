import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  final int value;
  final String unit;
  final String imageUrl;

  const WeatherItem({
    Key? key, required this.value, required this.unit, required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(imageUrl),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          value.toString() + unit, style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black45,
          fontSize: 17,
        ),
        ),
      ],
    );
  }
}