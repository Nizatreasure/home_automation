import 'package:flutter/material.dart';
import 'package:home_automation/provider.dart';
import 'package:home_automation/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider<ConnectionProvider>(
      create: (_) => ConnectionProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WelcomePage();
  }
}
