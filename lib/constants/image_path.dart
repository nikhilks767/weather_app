// import 'package:flutter/material.dart';

// class ImagePath {
//   static Widget getIcons(int code) {
//     if (code >= 200 && code <= 232) {
//       return Image.asset("assets/images/thunderstorm.png");
//     } else if (code >= 300 && code <= 321) {
//       return Image.asset("assets/images/drizzle.png");
//     } else if (code >= 500 && code <= 531) {
//       return Image.asset("assets/images/rain.png");
//     } else if (code >= 600 && code <= 622) {
//       return Image.asset("assets/images/snow.png");
//     } else if (code == 800) {
//       return Image.asset("assets/images/clear.png");
//     } else if (code >= 801 && code <= 804) {
//       return Image.asset("assets/images/clouds.png");
//     } else {
//       return Image.asset("assets/images/sunrise.png");
//     }
//   }
// }

Map<String, dynamic> imagePath = {
  "Clear": "assets/images/clear.png",
  "Clouds": "assets/images/clouds.png",
  "Drizzle": "assets/images/drizzle.png",
  "Snow": "assets/images/snow.png",
  "Thunderstorm": "assets/images/thunderstorm.png",
  "Rain": "assets/images/rain.png",
};
