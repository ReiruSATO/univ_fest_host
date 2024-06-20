import 'package:flutter/material.dart';
import 'package:univ_fest_host/main.dart';
import 'package:camera/camera.dart';

class ScanView extends StatelessWidget {
  const ScanView({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: MyScanPage(camera: camera),
    );
  }
}

class MyScanPage extends StatefulWidget {
  const MyScanPage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  // ignore: library_private_types_in_public_api
  _MyScanPageState createState() => _MyScanPageState();
}

class _MyScanPageState extends State<MyScanPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFutre;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFutre = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _initializeControllerFutre,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
