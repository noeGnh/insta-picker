library insta_picker;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_picker/src/models/options_model.dart';
import 'package:insta_picker/src/widgets/picker.dart';

export 'src/models/options_model.dart';

class InstaPicker {

  static Future<File> pick(BuildContext context, {Options options}) async
    => await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (ctx) => Picker(options: options ?? Options()))
    );

}