import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Control extends StatefulWidget {
  const Control({Key key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  double value = 0;
  double motorValue = 0;
  double motorValue2 = 0;
  BluetoothConnection connection;
  ConnectionProvider _provider;
  bool switchOn;

  void _sendMessageToBluetooth(String value) async {
    if (connection != null && connection.isConnected) {
      connection.output.add(utf8.encode("m0&" + value + ":" + "\r\n"));
      await connection.output.allSent;
      Fluttertoast.showToast(msg: getDisplayText(value));
    } else
      Fluttertoast.showToast(msg: "Device not connected");
  }

  String getDisplayText(String text) {
    String displayText = "";
    switch (text) {
      case "0":
        displayText = "Light Turned Off";
        _provider.updateLightStatus(false);
        _provider.updateLightColor("None");
        setState(() {
          value = 0;
        });
        break;
      case "1":
        displayText = "Light turned on";
        _provider.updateLightStatus(true);
        _provider.updateLightColor("White");
        break;
      case "R":
        displayText = "Light is red";
        _provider.updateLightStatus(true);
        _provider.updateLightColor("Red");

        break;
      case "G":
        displayText = "Light is green";
        _provider.updateLightStatus(true);
        _provider.updateLightColor("Green");

        break;
      case "B":
        displayText = "Light is blue";
        _provider.updateLightStatus(true);
        _provider.updateLightColor("Blue");

        break;
      default:
        displayText = "Action performed successfully";
    }
    return displayText;
  }

  void controlMotor(String motorDegree, int motorNumber) async {
    String motor = motorNumber == 1 ? "m1" : "m2";

    if (connection != null && connection.isConnected) {
      connection.output
          .add(utf8.encode(motor + "&" + motorDegree + ":" + "\r\n"));
      await connection.output.allSent;
      Fluttertoast.showToast(
          msg: 'motor$motorNumber turned by $motorDegree degrees');
      if (motorNumber == 1)
        _provider.updateMotorAngle(motorDegree);
      else
        _provider.updateMotorAngle2(motorDegree);
    } else
      Fluttertoast.showToast(msg: 'Device not connected');
  }

  @override
  void initState() {
    _provider = Provider.of<ConnectionProvider>(context, listen: false);
    if (_provider.lightColor != "White" && _provider.lightColor != "None") {
      value = _provider.lightColor == "Red"
          ? 0.33
          : _provider.lightColor == "Green"
              ? 0.67
              : 1.00;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    connection = _provider.connection;
    switchOn = Provider.of<ConnectionProvider>(context).isLightOn;
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Control',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0, 
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Button',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: switchOn ? Colors.green : Colors.black)),
                  Switch(
                    value: switchOn,
                    onChanged: (val) {
                      if (val) {
                        _sendMessageToBluetooth("1");
                      } else
                        _sendMessageToBluetooth("0");
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Color',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: getColor(value))),
                  Slider(
                    value: value,
                    onChanged: (val) {
                      if (_provider.connection != null &&
                          _provider.connection.isConnected) {
                        setState(() {
                          value = double.parse(val.toStringAsFixed(2));
                        });
                        if (val.toStringAsFixed(2) == '0.00') {
                          _sendMessageToBluetooth("1");
                        }
                        if (val.toStringAsFixed(2) == '0.33')
                          _sendMessageToBluetooth("R");
                        else if (val.toStringAsFixed(2) == '0.67')
                          _sendMessageToBluetooth("G");
                        else if (val.toStringAsFixed(2) == '1.00')
                          _sendMessageToBluetooth("B");
                      }
                    },
                    divisions: 3,
                    activeColor: getColor(value),
                    label: value == 0.00
                        ? ''
                        : value == 0.33
                            ? 'R'
                            : value == 0.67
                                ? 'G'
                                : 'B',
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Motor 1',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(
                      height: 300,
                      padding: EdgeInsets.only(left: 20),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 180,
                            startAngle: 130,
                            endAngle: 50,
                            backgroundImage:
                                const AssetImage('assets/dark_theme_gauge.png'),
                            axisLineStyle: AxisLineStyle(color: Colors.red),
                            axisLabelStyle: GaugeTextStyle(color: Colors.white),
                            annotations: [
                              GaugeAnnotation(
                                  widget: Text(
                                motorValue.toStringAsFixed(1),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ))
                            ],
                            tickOffset: 45,
                            labelOffset: 5,
                            pointers: [
                              NeedlePointer(
                                  enableDragging: true,
                                  animationType: AnimationType.slowMiddle,
                                  value: motorValue,
                                  needleEndWidth: 10,
                                  needleColor: Colors.white70,
                                  onValueChangeEnd: (val) {
                                    controlMotor(val.round().toString(), 1);
                                  },
                                  onValueChanging: (val) {
                                    setState(() {
                                      motorValue = val.value;
                                    });
                                  })
                            ],
                            showAxisLine: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Motor 2',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(
                      height: 300,
                      padding: EdgeInsets.only(left: 20),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 180,
                            startAngle: 130,
                            endAngle: 50,
                            backgroundImage:
                                const AssetImage('assets/dark_theme_gauge.png'),
                            axisLineStyle: AxisLineStyle(color: Colors.red),
                            axisLabelStyle: GaugeTextStyle(color: Colors.white),
                            annotations: [
                              GaugeAnnotation(
                                  widget: Text(
                                motorValue2.toStringAsFixed(1),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ))
                            ],
                            tickOffset: 45,
                            labelOffset: 5,
                            pointers: [
                              NeedlePointer(
                                  enableDragging: true,
                                  animationType: AnimationType.slowMiddle,
                                  value: motorValue2,
                                  needleEndWidth: 10,
                                  needleColor: Colors.white70,
                                  onValueChangeEnd: (val) {
                                    controlMotor(val.round().toString(), 2);
                                  },
                                  onValueChanging: (val) {
                                    setState(() {
                                      motorValue2 = val.value;
                                    });
                                  })
                            ],
                            showAxisLine: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(double val) {
    if (val == 0.00)
      return Colors.white;
    else if (val == 0.33)
      return Colors.red;
    else if (val == 0.67)
      return Colors.green;
    else
      return Colors.blue;
  }
}
