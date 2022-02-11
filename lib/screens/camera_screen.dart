import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);
  static const String routeName = '/camera-screen';
  final List<CameraDescription> cameras;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // CameraController? controller;
  //
  // initCameras() async {
  //   controller = CameraController(widget.cameras[0], ResolutionPreset.max);
  //   controller!.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }

  CameraImage? cameraImage;
  CameraController? cameraController;
  String result = "loading";
  bool frontCamera = true;

  initCamera() {
    cameraController =
        CameraController(widget.cameras[1], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        cameraController!.startImageStream((imageStream) {
          cameraImage = imageStream;
          // runModel();
        });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      // labels: "assets/labels.txt"
    );
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 0.6,
            child: CameraPreview(cameraController!),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(result),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        frontCamera = !frontCamera;
                      });
                    },
                    icon: const Icon(
                      Icons.camera_front,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
