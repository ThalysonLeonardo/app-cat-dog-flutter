import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());
File _image;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(
        children: <Widget>[
          Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*RaisedButton(
                onPressed: _choose,
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              */
              RaisedButton(
                onPressed: _upload,
                child: Text('Upload Image'),
              )
            ],
          ),
      ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

// My IPv4 : 192.168.43.171 
final String pythonEndPoint = 'https://cat-or-dog-api.herokuapp.com/image/predict/';
final String nodeEndPoint = 'http://192.168.43.171:3000/image';
File file;
/*
 void _choose() async {
   file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
 }
*/
 void _upload() {
   if (_image == null) return;
   String base64Image = base64Encode(_image.readAsBytesSync());
   //String fileName = file.path.split("/").last;

   http.post(pythonEndPoint, body: {
    "imagemFile": base64Image,
    //"imagemFile":_image.readAsBytesSync()
    // "name": fileName,
   }).then((res) {
     print(res.statusCode);
   }).catchError((err) {
     print(err);
   });
 }