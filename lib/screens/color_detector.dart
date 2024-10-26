import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:useless_app/utils/common.dart';

class ColorDetector extends StatefulWidget {
  const ColorDetector({Key? key}) : super(key: key);

  @override
  _ColorDetectorState createState() => _ColorDetectorState();
}

class _ColorDetectorState extends State<ColorDetector> {
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    final cameras = await availableCameras();
    setState(() {
      _cameras = cameras;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameras == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "Pointless Detector",
            style: TextStyle(
                fontSize: 24,
                fontWeight: ui.FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: CameraApp(
          cameras: _cameras!,
        ));
  }
}

class CameraApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraApp({super.key, required this.cameras});

  @override
  // ignore: library_private_types_in_public_api
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  bool isProcessing = false;
  List<Color> dominantColors = List.empty();
  late CameraController _controller;
  String imageString = "";
  ui.Color? _displayedColor =
      const Color.fromRGBO(255, 200, 255, 1); // Default white
  Color? domi = const Color.fromRGBO(255, 255, 255, 1);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    await _controller.initialize();
    setState(() {});
  }

  Future<void> _extractColors(String imagePath) async {
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(FileImage(File(imagePath)));

    setState(() {
      domi = paletteGenerator.dominantColor?.color;
      isProcessing = false;
    });
  }

  void _captureAndProcessFrame() async {
    if (_controller.value.isInitialized) {
      dominantColors = List.empty();
      final frame = await _controller.takePicture();
      final path = frame.path;

      setState(() {
        _extractColors(path);
        domi = dominantColors.first;
        _displayedColor = domi;
        isProcessing = false;
      });
    }
    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        SizedBox(
            height: context.height() / 2,
            width: context.width(),
            child: CameraPreview(_controller)),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Detected Color :',
                style: TextStyle(fontSize: 32, fontWeight: ui.FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                    color: domi, borderRadius: BorderRadius.circular(32)),
                width: 70,
                height: 70,
              ),
            ],
          ),
        ),

        // Text(imageString),
        isProcessing
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  HorizontalList(
                    itemCount: dominantColors.length,
                    spacing: 16,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemBuilder: (context, index) => Container(
                      color: dominantColors[index],
                      child: Text(dominantColors[index].toString()),
                    ),
                  ),
                  IconButton(
                      iconSize: 64,
                      onPressed: () {
                        setState(() {
                          isProcessing = true;
                        });
                        _captureAndProcessFrame();
                      },
                      color: Colors.green,
                      icon: const Icon(Icons.camera))
                ],
              ),
      ],
    );
  }
}
