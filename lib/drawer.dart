import 'package:flutter/material.dart';
import 'package:home_automation/connect.dart';
import 'package:home_automation/control.dart';
import 'package:home_automation/status.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ConnectDevice()));
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Connect',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Control()));
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Control',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Status()));
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Status',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                  )),
              TextButton(
                onPressed: () {},
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'More',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        )),
      ),
    );
  }
}
