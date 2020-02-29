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
        title: Text('Reconhecedor de Cães e Gatos'),
      ),
      body: Column(
        children: <Widget>[
      Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed:() async {
                final result = await _upload();
                print("--"+result+"--");
                _mostrarResposta(context,result);
                },
                child: Text('Enviar Imagem'),
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
String animal="";
final String texto="";
/*
 void _choose() async {
   file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
 }
*/
Future<String> _upload() async{
  print("enviando imagem...");
    var uri = Uri.parse(uploadURL);
    var request = new http.MultipartRequest("POST", uri);
    request.files.add( new http.MultipartFile.fromBytes("imageFile", _image.readAsBytesSync(), filename: "photo.jpg"));
    print("aguardando resposta...");
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value){
      if(value.contains('Cachorro')){
        print("<Cachorro>");
        animal = "Cachorro";
      }else if(value.contains('Gato')){
        print("<Gato>");
         animal = "Gato";
      }else{
        print("<Sem-Resposta-Servidor>");
        animal = "Sem-Resposta-Servidor";
      }
    });
  return animal;
}

void _showMessage(BuildContext context, String texto){
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  AlertDialog alerta = AlertDialog(
    title: Text("A resposta é:"),
    content: Text(texto), contentTextStyle: TextStyle(color: Colors.black),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

void _mostrarResposta(BuildContext context,String texto) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("> A resposta é:< "),
        content: Text(texto), contentTextStyle: TextStyle(color: Colors.black),
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