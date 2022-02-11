import 'package:abet/screens/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.cameras}) : super(key: key);
  static const String routeName = '/splash-screen';
  final List<CameraDescription> cameras;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _changeScreen() async {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => CameraScreen(cameras: widget.cameras)));
    });
  }

  @override
  void initState() {
    super.initState();
    _changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Abet'),
      ),
    );
  }
}
