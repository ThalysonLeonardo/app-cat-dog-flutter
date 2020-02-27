import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

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
 
/*
 void _choose() async {
   file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
 }
*/

  Future getImage() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reconhecedor de Cães e Gatos'),
      ),
      body: Column(
        children: <Widget>[
      Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed:() async { 
                  String result = await _upload();
                  print("resultado:" + result);
                  _showDialog(context,result);

                },
                child: Text('Upload Image'),
              ),
            ],
          ),
          Center(
        child: _image == null
            ? Text('Nenhuma imagem foi selecionada.')
            : Image.file(_image),
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
final String uploadURL = 'https://cat-or-dog-api.herokuapp.com/image/predict/';
File file;
String animal;


Future<String> _upload() async{
  
  print("enviando imagem...");
    var uri = Uri.parse(uploadURL);
    var request = new http.MultipartRequest("POST", uri);
    request.files.add( new http.MultipartFile.fromBytes("imageFile", _image.readAsBytesSync(), filename: "photo.jpg"));
    print("aguardando resposta...");
    var response = await request.send();
    
    response.stream.transform(utf8.decoder).listen((value){
      print(value);
      if(value.contains("Cachorro")){
        print("Cachorro");
        animal =  "Cachorro";
        
      }else{
        if(value.contains("Gato")){
          print("Gato");
          animal =  "Gato";
          
        }else{
          print("Sem resposta do servidor");
          animal =  "Sem resposta do servidor";

        }
      } 
    });
  return animal;
}


// user defined function
  void _showDialog(BuildContext context,String texto) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Este animal é um:"),
          content: new Text(texto + "!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

