import 'package:abet/screens/camera_screen.dart';
import 'package:abet/screens/splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(cameras: cameras!),
        CameraScreen.routeName: (context) => CameraScreen(
              cameras: cameras!,
            ),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
