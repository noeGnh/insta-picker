import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_picker/insta_picker.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Example",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("Example"),
          ),
          body: Content()
        ),
    );
  }
}

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {

  File image;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            child: image != null ? Image.file(image) : Container(),
          ),
          RaisedButton(
            onPressed: () async {
              InstaPickerResult result = await InstaPicker.pick(context, options: Options(allowMultiple: false));
              image = result.pickedFiles[0].file;
              print(result.pickedFiles);
              setState(() {});
            },
            child: Text('Pick It'),
          )
        ],
      ),
    );
  }
}

