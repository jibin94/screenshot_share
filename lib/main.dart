import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Share Screenshot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();


  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          child: new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'This a demo for screenshot share in flutter',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            _takeScreenshotAndShare();
          },
          tooltip: 'Increment',
          child: Icon(Icons.share,color: Colors.white),
        ),
      ),
    );
  }

  _takeScreenshotAndShare() async {
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((Uint8List? imageBytes) async {
      // Assuming this is the correct type
      // Proceed only if imageBytes is not null
      if (imageBytes != null) {
        setState(() {
          // Assuming you have a way to display Uint8List directly,
          // If not, you might need to write it to a file first
          //_imageBytes = imageBytes; // Make sure _imageBytes is of type Uint8List?
        });
        final directory = (await getApplicationDocumentsDirectory()).path;
        File imgFile = new File('$directory/screenshot.png');
        await imgFile.writeAsBytes(imageBytes);
        print("File Saved to Gallery");

        await Share.file(
            'screen share', 'screenshot.png', imageBytes, 'image/png');
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
