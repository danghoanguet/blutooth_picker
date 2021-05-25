import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_control/configs/app_size.dart';
import 'package:bluetooth_control/constants/app_color.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ControlScreen({required this.device});

  @override
  _ControlScreen createState() => new _ControlScreen();
}

class _ControlScreen extends State<ControlScreen> {
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool isDisconnecting = false;
  bool get isConnected => connection != null && connection!.isConnected;

  bool turnOnLCD = false;

  @override
  void initState() {
    super.initState();
    connectDevice();
  }

  void connectDevice() {
    BluetoothConnection.toAddress(widget.device.address).then((_connection) {
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.device.name)),
      body: SafeArea(
        child: isConnected
            ? buildControlButton()
            : Center(child: Text("Disconnected")),
      ),
    );
  }

  buildControlButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (isConnected) {
            setState(() {
              setState(() {
                turnOnLCD = !turnOnLCD;
              });
            });
            sendMessage();
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: SizeConfig.defaultSize * 6,
          height: SizeConfig.defaultSize * 6,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            shape: BoxShape.circle,
          ),
          child: turnOnLCD
              ? Icon(
                  Icons.stop,
                  color: AppColor.white,
                  size: SizeConfig.defaultSize * 2,
                )
              : Icon(
                  Icons.play_arrow,
                  color: AppColor.white,
                  size: SizeConfig.defaultSize * 2,
                ),
        ),
      ),
    );
  }

  void sendMessage() async {
    try {
      String msg = turnOnLCD ? "1" : "0";
      var data = Uint8List.fromList(utf8.encode(msg));
      print(data.toString());
      // connection!.output.add(data);
      // await connection!.output.allSent;
    } catch (e) {
      setState(() {});
    }
  }
}
