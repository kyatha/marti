import 'package:flutter/material.dart';
import 'package:insuranceapp/Screens/onboarding.dart';
import 'Auth/LandingPage.dart';
import 'Auth/Landing2.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'EasyFind',
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Raleway'),
      home: new OnboardingScreen(),
      // home: DetailPage(),
    );
  }
}