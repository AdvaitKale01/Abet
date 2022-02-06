import 'package:abet/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
