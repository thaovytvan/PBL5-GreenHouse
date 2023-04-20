import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;


import 'package:flutter/material.dart';
import 'package:green_garden/components/temphumi.dart';
import 'package:green_garden/components/circleprogress.dart';
import 'package:green_garden/constants.dart';
import 'package:green_garden/components/weather_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// const String esp_url = 'ws://192.168.222.197:8080';
// final channel = IOWebSocketChannel.connect('ws://192.168.222.197:8080');

class OverviewTabBar extends StatefulWidget {
  const OverviewTabBar({Key? key}) : super(key: key);
  @override
  State<OverviewTabBar> createState() => _OverviewTabBarState();
}
class _OverviewTabBarState extends State<OverviewTabBar>{
  //websocket
  late IOWebSocketChannel channel;
  String _temperature = "0";
  String _humidity = "0";
  String _anaValue = "0";
  //
  static String API_KEY = "681e5b5e20904435973142220232802"; //Paste Your API Here
  String location = 'Danang'; //Default location
  String weatherIcon = 'heavycloudy.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;

  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';


  //dht11
  bool isLoaded = false;
  String msg = '';
  TempHumi dht = TempHumi(0, 0);
  // final channel = IOWebSocketChannel.connect(esp_url);

  //API Call
  String searchWeatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=" +
      API_KEY +
      "&days=7&q=";
  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
      await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];

      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);
        //
        var parsedDate =
        DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;


        //updateWeather
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        //Forecast data
        // dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        // hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        // print(dailyWeatherForecast);
      });
    } catch (e) {
      //debugPrint(e);
    }
  }

  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  //dht11, do am dat
  // double soilMoistureValue = 0;

  @override
  void initState() {
    super.initState();
    fetchWeatherData(location);
    channel = IOWebSocketChannel.connect("ws://192.168.152.80:8080");
    channel.stream.listen((data) {
      try {
        final messageObj = json.decode(data);
        setState(() {
          _temperature = messageObj['temperature'].toString();
          _humidity = messageObj['humidity'].toString();
          _anaValue = messageObj['anaValue'].toString();
        });
      } catch (e) {
        print("Error: $e");
      }
    });

    // channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.222.197:8080'));
    // channel.stream.listen((data) {
    //   try {
    //     final messageObj = json.decode(data);
    //     setState(() {
    //       _temperature = messageObj['temperature'].toString();
    //       print('$_temperature');
    //       _humidity = messageObj['humidity'].toString();
    //       _anaValue = messageObj['anaValue'].toString();
    //     });
    //   } catch (e) {
    //     print("Error: $e");
    //   }
    // });
    // channel.stream.listen(
    //       (message) {
    //     channel.sink.add('Flutter received $message');
    //     if (message == "connected") {
    //       print('Received from MCU: $message');
    //       setState(() {
    //         msg = message;
    //       });
    //     } else {
    //       print('Received from MCU: $message');
    //       // {'tempC':'30.50','humi':'64.00'}
    //       Map<String, dynamic> json = jsonDecode(message);
    //       setState(() {
    //         soilMoistureValue = double.parse(message);
    //         dht = TempHumi.fromJson(json);
    //         isLoaded = true;
    //       });
    //     }
    //     //channel.sink.close(status.goingAway);
    //   },
    //   onDone: () {
    //     //if WebSocket is disconnected
    //     print("Web socket is closed");
    //     setState(() {
    //       msg = 'disconnected';
    //       isLoaded = false;
    //     });
    //   },
    //   onError: (error) {
    //     print(error.toString());
    //   },
    // );
    // Fluttertoast.showToast(${msg});
  }
  // void _fetchData() {
  //   try {
  //     final messageObj = json.decode(channel.lastMessage.data);
  //     setState(() {
  //       _temperature = messageObj['temperature'].toString();
  //       _humidity = messageObj['humidity'].toString();
  //       _anaValue = messageObj['anaValue'].toString();
  //     });
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }
  // @override
  // void initState() {
  //   fetchWeatherData(location);
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  SingleChildScrollView(
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 500,
            child: ListView(// <---- Here
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, top: 7),
                  child: const Text(
                    'Outside',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      margin: const EdgeInsets.all(10),
                      height: size.height * .17,
                      width: size.width * .94,
                      decoration: BoxDecoration(
                        gradient: Constants.linearGradientBlue,
                        boxShadow: [
                          BoxShadow(
                            color: Constants.primaryColor.withOpacity(.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),

                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/" + weatherIcon,
                            height: 130,
                            width: 130,
                            fit: BoxFit.fitWidth,
                          ),
                          SizedBox(width: size.width * 0.15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                  children: [
                                    Text(
                                      currentDate,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    temperature.toString(),
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'O',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: size.width * 0.05),
                              Text(
                                currentWeatherStatus,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],

                          ),
                        ],
                      ),

                    ),
                  ],

                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WeatherItem(
                        value: windSpeed.toInt(),
                        unit: 'km/h',
                        imageUrl: 'assets/windspeed.png',
                      ),
                      WeatherItem(
                        value: humidity.toInt(),
                        unit: '%',
                        imageUrl: 'assets/humidity.png',
                      ),
                      WeatherItem(
                        value: cloud.toInt(),
                        unit: '%',
                        imageUrl: 'assets/cloud.png',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, top: 7),
                  child: const Text(
                    'Inside',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomPaint(
                      foregroundPainter:
                      CircleProgress(double.parse(_temperature), true),
                      child: Container(
                        width: 190,
                        height: 190,
                        child: Center(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Air Temperature'),
                              Text(
                               '$_temperature',
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '°C',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      foregroundPainter:
                      CircleProgress(double.parse(_humidity), false),
                      // CircleProgress(humidityAnimation.value, false),


                      child: Container(
                        width: 190,
                        height: 190,
                        child: Center(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Air Humidity'),
                              Text(
                                '$_humidity',
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '%',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomPaint(
                  foregroundPainter:
                  // CircleProgress(humidityAnimation.value, false),
                  CircleProgress(double.parse(_anaValue), false),

                  child: Container(
                    width: 190,
                    height: 190,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Soil Humidity'),
                          Text(
                             '$_anaValue',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],//children
            ),
          ),


          // coding
        ],
      ),
    );

  }

}


