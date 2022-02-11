// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';
//
// class CameraScreen extends StatefulWidget {
//   const CameraScreen({Key? key, required this.cameras}) : super(key: key);
//   static const String routeName = '/camera-screen';
//   final List<CameraDescription> cameras;
//
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   // CameraController? controller;
//   //
//   // initCameras() async {
//   //   controller = CameraController(widget.cameras[0], ResolutionPreset.max);
//   //   controller!.initialize().then((_) {
//   //     if (!mounted) {
//   //       return;
//   //     }
//   //     setState(() {});
//   //   });
//   // }
//
//   CameraImage? cameraImage;
//   CameraController? cameraController;
//   String result = "loading";
//   bool frontCamera = true;
//
//   initCamera() {
//     cameraController =
//         CameraController(widget.cameras[1], ResolutionPreset.medium);
//     cameraController!.initialize().then((value) {
//       if (!mounted) return;
//       setState(() {
//         cameraController!.startImageStream((imageStream) {
//           cameraImage = imageStream;
//           runModel();
//         });
//       });
//     });
//   }
//
//   loadModel() async {
//     await Tflite.loadModel(
//         model: "assets/models/model_unquant.tflite",
//         // model: "assets/models/model.tflite",
//         labels: "assets/models/labels.txt");
//   }
//
//   runModel() async {
//     if (cameraImage != null) {
//       var recognitions = await Tflite.runModelOnFrame(
//           bytesList: cameraImage!.planes.map((plane) {
//             return plane.bytes;
//           }).toList(),
//           imageHeight: cameraImage!.height,
//           imageWidth: cameraImage!.width,
//           imageMean: 127.5,
//           imageStd: 127.5,
//           rotation: 90,
//           numResults: 2,
//           threshold: 0.1,
//           asynch: true);
//       recognitions!.forEach((element) {
//         setState(() {
//           result = element["label"];
//           print(result);
//         });
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//     loadModel();
//   }
//
//   @override
//   void dispose() {
//     cameraController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!cameraController!.value.isInitialized) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     return Scaffold(
//       body: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: .6,
//             child: CameraPreview(cameraController!),
//           ),
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.1),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     result,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 25),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       setState(() {
//                         frontCamera = !frontCamera;
//                       });
//                     },
//                     icon: const Icon(
//                       Icons.camera_front,
//                       size: 40,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;
  static const routeName = '/camera-screen';
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String result = "";

  initCamera() {
    cameraController =
        CameraController(widget.cameras[1], ResolutionPreset.ultraHigh);
    cameraController!.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        cameraController!.startImageStream((imageStream) {
          cameraImage = imageStream;
          runModel();
        });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/models/model_unquant.tflite",
        labels: "assets/models/labels.txt");
  }

  runModel() async {
    if (cameraImage != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);

      recognitions?.forEach((element) {
        setState(() {
          result = element["label"];
          print(result);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Face Mask Detector"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                child: !cameraController!.value.isInitialized
                    ? Container()
                    : AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      ),
              ),
            ),
            Text(
              result,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
