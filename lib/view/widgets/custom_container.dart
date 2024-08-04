// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final double? scale;
  const CustomContainer(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle,
      this.scale});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(image, scale: scale!),
        SizedBox(width: 9),
        Column(
          children: [
            Text(title, style: TextStyle(color: Colors.white)),
            Text(subtitle, style: TextStyle(color: Colors.white)),
          ],
        )
      ],
    );
  }
}
