import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";
  void getImage(ImageSource source) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognizedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
      scannedText = "Error ocurred while scanning";
    }
  }

  void getRecognizedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

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
            if (!textScanning && imageFile == null)
              Container(height: 500, width: 300, color: Colors.grey[200]),
            if (imageFile != null) Image.file(File(imageFile!.path)),
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
