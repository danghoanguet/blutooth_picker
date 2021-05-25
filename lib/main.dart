// @dart = 2.9

import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_control/configs/configs.dart';
import 'package:flutter/material.dart';

import 'app_view.dart';

void main() {
  String msg = "1";
  var data = Uint8List.fromList(utf8.encode(msg));
  print(data);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return AppView();
        });
      },
    );
  }
}
