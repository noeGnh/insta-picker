import 'package:flutter/material.dart';

class PickerProvider extends ChangeNotifier{

  BuildContext _context;

  void init(BuildContext context){
    this._context = context;
  }

}