import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:robot/ScannerUtils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 152, 151),
        title: Text("Leitor de Imagem"),
      ),
      drawer: NavigationDrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _camera == null
                ? Container(height: 500, width: 300, color: Colors.grey[200])
                : Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: CameraPreview(_camera)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Image',
        backgroundColor: Color.fromARGB(255, 140, 152, 151),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: Colors.amber,
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20),
                const SizedBox(
                  child: Align(
                      alignment: Alignment(-0.5, 0.0),
                      child: Text(
                        'Ócio Criativo',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 30,
                          color: Colors.grey,
                          height: 1,
                        ),
                      )),
                ),
                const SizedBox(height: 20),
                buildMenuItem(
                    icon: Icons.piano,
                    text: 'Estudio',
                    onClicked: () => selectedItem(context, 0)),
                const SizedBox(height: 5),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 5),
                buildMenuItem(
                    icon: Icons.dashboard,
                    text: 'Escalas',
                    onClicked: () => selectedItem(context, 1)),
              ],
            )));
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.grey;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onClicked,
    );
  }

  Widget buildMenuItem1({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.amber;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onClicked,
    );
  }
}

selectedItem(BuildContext context, int index) {
  switch (index) {
    case 0:
      break;
    case 1:
      break;
  }
}

bool _isDetecting = false;

late VisionText _textScanResults;

late CameraLensDirection _direction = CameraLensDirection.back;

late CameraController _camera;

final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();

@override
void initState() {
  _initializeCamera();
}

void _initializeCamera() async {
  final CameraDescription description =
      await ScannerUtils.getCamera(_direction);

  _camera = CameraController(
    description,
    ResolutionPreset.high,
  );

  await _camera.initialize();

  _camera.startImageStream((CameraImage image) {
    if (_isDetecting) return;

    setState(() {
      _isDetecting = true;
    });
    ScannerUtils.detect(
      image: image,
      detectInImage: _getDetectionMethod(),
      imageRotation: description.sensorOrientation,
    ).then(
      (results) {
        setState(() {
          if (results != null) {
            setState(() {
              _textScanResults = results;
            });
          }
        });
      },
    ).whenComplete(() => _isDetecting = false);
  });
}

void setState(Null Function() param0) {}

Future<VisionText> Function(FirebaseVisionImage image) _getDetectionMethod() {
  return _textRecognizer.processImage;
}
