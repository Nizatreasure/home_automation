import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation/provider.dart';
import 'package:provider/provider.dart';

class ConnectDevice extends StatefulWidget {
  ConnectDevice({Key key}) : super(key: key);

  @override
  _ConnectDeviceState createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice>
    with SingleTickerProviderStateMixin {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> _devicesList = [];
  bool isDisconnecting = false;
  bool _connected = false;
  BluetoothDevice _device;
  ConnectionProvider _provider;
  bool _isButtonUnavailable = false;
  AnimationController _controller;
  Animation<double> _animation;
  bool switchOn = false;
  // fb.FlutterBlue flutterBlue = fb.FlutterBlue.instance;
  // StreamSubscription subscription;
  // List<fb.ScanResult> foundDevices = [];

  bool get isConnected => connection != null && connection.isConnected;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ConnectionProvider>(context, listen: false);
    connection = _provider.connection;
    if (isConnected) {
      setState(() {
        _connected = true;
      });
      _device = _provider.device;
    }
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
      });
    });
//     flutterBlue.startScan(timeout: Duration(seconds: 4));
//     subscription = flutterBlue.scanResults.listen((results) {
//       // do something with scan results
//       for (fb.ScanResult r in results) {
//         print('${r.device.id} with ${r.device.name} found! rssi: ${r.rssi}');
//       }
//       foundDevices = results;
//     });

// // Stop scanning
//     flutterBlue.stopScan();

    enableBluetooth();

    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      setState(() {
        _bluetoothState = state;
        getPairedDevices();
        if (_bluetoothState == BluetoothState.STATE_ON)
          _isButtonUnavailable = false;
      });
    });
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      Fluttertoast.showToast(msg: 'No device selected');
      setState(() {
        _isButtonUnavailable = false;
      });
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;

          _provider.updateConnection(connection);
          _provider.updateDevice(_device);

          setState(() {
            _connected = true;
            isDisconnecting = false;
          });

          connection.input.listen(null).onDone(() {
            _provider.updateConnection(connection);
            _provider.updateDevice(null);
            _provider.updateLightColor("None");
            _provider.updateLightStatus(false);
            _provider.updateMotorAngle('0');
            _provider.updateMotorAngle2('0');
            Fluttertoast.showToast(msg: 'Device disconnected');
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        Fluttertoast.showToast(msg: 'Device connected');
        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    await connection.close();
    _provider.updateConnection(connection);
    _provider.updateDevice(null);
    _provider.updateLightColor("None");
    _provider.updateLightStatus(false);
    _provider.updateMotorAngle('0');
    _provider.updateMotorAngle2('0');
    Fluttertoast.showToast(msg: 'Device disconnected');

    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Connect to device'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton.icon(
              onPressed: () async {
                _controller.forward()..whenComplete(() => _controller.reset());

                await getPairedDevices();
              },
              icon: RotationTransition(
                  turns: _animation, child: Icon(Icons.refresh)),
              label: Text('Refresh'))
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: (bool value) {
              future() async {
                if (value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }

                await getPairedDevices();
                _isButtonUnavailable = false;

                if (_connected) {
                  _disconnect();
                }
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Device:',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                DropdownButton(
                  items: _getDeviceItems(),
                  iconEnabledColor: Colors.black,
                  onChanged: (value) {
                    setState(() => _device = value);
                  },
                  value: _devicesList.isNotEmpty && _device != null
                      ? _device
                      : null,
                  hint: Text('Select a device'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isButtonUnavailable
                      ? null
                      : _connected
                          ? _disconnect
                          : _connect,
                  child: Text(_connected ? 'Disconnect' : 'Connect'),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: Text("Bluetooth Settings"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      elevation: MaterialStateProperty.all<double>(2),
                    ),
                    onPressed: () {
                      FlutterBluetoothSerial.instance.openSettings();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
