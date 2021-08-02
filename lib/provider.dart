import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ConnectionProvider extends ChangeNotifier {
  BluetoothConnection connection;
  BluetoothDevice device;
  bool isLightOn = false;
  String motorAngle = "0";
  String motorAngle2 = "0";
  String lightColor = "None";

  void updateConnection(BluetoothConnection connection) {
    this.connection = connection;
    notifyListeners();
  }

  void updateDevice(BluetoothDevice device) {
    this.device = device;
    notifyListeners();
  }

  void updateLightStatus(bool status) {
    isLightOn = status;
    notifyListeners();
  }

  void updateMotorAngle(String angle) {
    motorAngle = angle;
    notifyListeners();
  }

  void updateMotorAngle2(String angle) {
    motorAngle2 = angle;
    notifyListeners();
  }

  void updateLightColor(String color) {
    lightColor = color;
    notifyListeners();
  }
}
