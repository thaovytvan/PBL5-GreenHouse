import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:green_garden/components/weather_item.dart';
import 'package:green_garden/constants.dart';
import 'package:green_garden/ui/scan_page.dart';
import 'package:page_transition/page_transition.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
    State<HomePage> createState() => _HomePageState();


  
}


class _HomePageState extends State<HomePage>{
  int _bottomNavIndex = 0;
  List<IconData> iconList = [
    Icons.home,
    Icons.settings,
  ];

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
  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return SafeArea(
     child: Scaffold(
       appBar: AppBar(
         title: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text('Home', style: TextStyle(
               color: Constants.blackColor,
               fontWeight: FontWeight.w500,
               fontSize: 24,
             ),),
             Icon(Icons.notifications, color: Constants.blackColor, size: 30.0,)
           ],
         ),

         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
         elevation: 0.0,

       ),

      body: Padding(
        padding: const EdgeInsets.all(0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
             children: [
             Container(
              margin: const EdgeInsets.all(10.0),
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row (
                      children:[
                        Image.asset(
                          "assets/pin.png",
                          width: 20,
                          color: Colors.black,
                        ),
                        Text(
                          location ,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ]
                    ),
                 const Text(
                    'Hello, Michael',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
             ],
             ),

            ),
               Container(
                 padding: const EdgeInsets.only(top: .5),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Container(
                       padding: const EdgeInsets.symmetric(
                         horizontal: 16.0,
                       ),
                       width: size.width * .9,
                       decoration: BoxDecoration(
                         color: Constants.primaryColor.withOpacity(.1),
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child:  Row(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(
                             Icons.search,
                             color: Colors.black54.withOpacity(.6),
                           ),
                           const Expanded(
                               child: TextField(
                                 showCursor: false,
                                 decoration: InputDecoration(
                                   hintText: ' Search History',
                                   border: InputBorder.none,
                                   focusedBorder: InputBorder.none,
                                 ),
                               )),
                           Icon(
                             Icons.mic,
                             color: Colors.black54.withOpacity(.6),
                           ),
                         ],
                       ),
                     )
                   ],
                 ),
               ),
               const SizedBox(
                 height: 5.0,
               ),
              
               Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: const EdgeInsets.all(10),
                    height: size.height * .17,
                    width: size.width * .95,
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
                              ]
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
                                  ' O',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 40,
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
                                fontSize: 30.0,
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
            ],

      ),
      ),

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

    ),
    );
  }
}

