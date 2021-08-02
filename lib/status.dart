import 'package:flutter/material.dart';
import 'package:home_automation/provider.dart';
import 'package:provider/provider.dart';

class Status extends StatefulWidget {
  Status({Key key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  ConnectionProvider _provider;

  @override
  void initState() {
    _provider = Provider.of<ConnectionProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String lightColor = _provider.lightColor;
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Status'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Device status",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  _provider.connection != null &&
                          _provider.connection.isConnected
                      ? "Connected"
                      : "Not connected",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Light status",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  _provider.isLightOn ? "ON" : "OFF",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Light color",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  lightColor,
                  style: TextStyle(
                      color: lightColor == "None" || lightColor == "White"
                          ? Colors.white
                          : lightColor == 'Red'
                              ? Colors.red
                              : lightColor == "Green"
                                  ? Colors.green
                                  : Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Motor 1 position",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(_provider.motorAngle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Motor2 position",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(_provider.motorAngle2,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
