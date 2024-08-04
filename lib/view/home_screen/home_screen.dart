// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants/image_path.dart';
import 'package:weather_app/controller/location_controller.dart';
import 'package:weather_app/service/api_service.dart';
import 'package:weather_app/view/widgets/custom_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      locationProvider.determinePosition().then((_) {
        if (locationProvider.currentLocationName != null) {
          var city = locationProvider.currentLocationName!.locality;
          if (city != null) {
            Provider.of<ApiService>(context, listen: false).fetchData(city);
          }
        }
      });
    });
    super.initState();
  }

  bool isClicked = false;
  TextEditingController cityNamecontroller = TextEditingController();
  String enteredCityName = "";

  Future<void> _onRefresh() async {
    setState(() {
      isClicked = false;
      enteredCityName = "";
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      locationProvider.determinePosition().then((_) {
        if (locationProvider.currentLocationName != null) {
          var city = locationProvider.currentLocationName!.locality;
          if (city != null) {
            Provider.of<ApiService>(context, listen: false).fetchData(city);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final location = Provider.of<LocationProvider>(context);
    final cityWeather = Provider.of<ApiService>(context).weather;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.1,
              left: size.width * 0.45,
              child: Container(
                width: size.width * 0.55,
                height: 600,
                decoration:
                    BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: size.height * 0.1,
              right: size.width * 0.45,
              child: Container(
                width: size.width * 0.55,
                height: 600,
                decoration:
                    BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: 0,
              left: size.width * 0.065,
              child: Container(
                width: size.width * 0.85,
                height: 250,
                decoration: BoxDecoration(color: Colors.amber),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 110, sigmaY: 120),
              child: Container(
                height: size.height,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                String? cityName;
                if (locationProvider.currentLocationName != null) {
                  cityName = locationProvider.currentLocationName!.subLocality;
                } else {
                  cityName = null;
                }
                return SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 60),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("📍",
                                      style: TextStyle(
                                          color: Colors.red.shade600,
                                          fontSize: 20)),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      cityName == null
                                          ? SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white))
                                          : Text(cityName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          DateFormat.yMMMd()
                                              .format(DateTime.now()),
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isClicked = !isClicked;

                                      if (cityNamecontroller.text.isNotEmpty) {
                                        Provider.of<ApiService>(context,
                                                listen: false)
                                            .fetchData(cityNamecontroller.text);
                                        enteredCityName =
                                            cityNamecontroller.text;
                                        // cityName = cityNamecontroller.text;

                                        cityNamecontroller.clear();
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.search, color: Colors.white))
                            ],
                          ),
                          isClicked == true
                              ? SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: cityNamecontroller,
                                    cursorColor: Colors.white30,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: " Enter a city name",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      hintStyle: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 10),
                          isClicked == true
                              ? SizedBox.shrink()
                              : enteredCityName.isNotEmpty
                                  ? Text(enteredCityName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                                color: Colors.amber.shade500,
                                                blurRadius: 10)
                                          ],
                                          fontWeight: FontWeight.bold))
                                  : SizedBox.shrink(),
                          if (cityWeather != null)
                            Column(
                              children: [
                                SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: Image.asset(
                                      imagePath[cityWeather.weather![0].main]),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${cityWeather.main!.temp!.round().toString()}\u00B0 C",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 35),
                                ),
                                Text(
                                  cityWeather.weather![0].main!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                      fontSize: 28),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat.EEEE()
                                              .format(DateTime.now())
                                              .toString() +
                                          " | ",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 13),
                                    ),
                                    Text(
                                      DateFormat.jm().format(DateTime.now()),
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 80),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomContainer(
                                              scale: 15,
                                              image:
                                                  "https://cdn-icons-png.freepik.com/512/7340/7340001.png",
                                              title: "Max Temp",
                                              subtitle:
                                                  "${cityWeather.main!.tempMax.toString()}\u00B0 C"),
                                          CustomContainer(
                                              scale: 15,
                                              image:
                                                  "https://cdn0.iconfinder.com/data/icons/winter-bzzricon-flat/512/08_Low_Temperature-512.png",
                                              title: "Min Temp",
                                              subtitle:
                                                  "${cityWeather.main!.tempMin.toString()}\u00B0 C"),
                                        ],
                                      ),
                                      Divider(
                                          color: Colors.white70,
                                          endIndent: 35,
                                          indent: 45,
                                          height: 35),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomContainer(
                                            scale: 22,
                                            image:
                                                "https://img.pikbest.com/png-images/20240529/sun-3d-icon-smile_10588100.png!sw800",
                                            title: "Sunrise",
                                            subtitle: DateFormat.jm().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        cityWeather
                                                                .sys!.sunrise! *
                                                            1000)),
                                          ),
                                          CustomContainer(
                                            scale: 15,
                                            image:
                                                "https://clipart-library.com/img/1670175.png",
                                            title: "Sunset",
                                            subtitle: DateFormat.jm().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        cityWeather
                                                                .sys!.sunset! *
                                                            1000)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
