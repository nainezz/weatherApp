// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:weather/screen/home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: HomeScreen(),
    ),
  );
}
