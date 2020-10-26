library insta_picker;

import 'package:flutter/material.dart';
import 'package:insta_picker/src/widgets/picker.dart';

class InstaPicker {

  String title;
  BuildContext context;

  InstaPicker(BuildContext context, {this.title}) : this.context = context;

  static InstaPicker instance(BuildContext context, {String title}) => InstaPicker(context, title: title);

  pick(){
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (ctx) => Picker(title: title,))
    );
  }

}