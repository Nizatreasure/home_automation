import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:home_automation/drawer.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 8,
        title: Text(
          'Home Automation',
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[700],
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   'Home',
          //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
          // ),
          SizedBox(height: 30),
          CarouselSlider(
            items: [1, 2, 3, 4, 5, 6, 7].map((i) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                // decoration:
                //     BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: height * 0.5,
                child: ClipRRect(
                  child: Image.asset('assets/image$i.jpg', fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
            options: CarouselOptions(
                autoPlay: true,
                height: height * 0.5,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(seconds: 1)),
          ),
          SizedBox(height: 30),
          // Text(
          //   'Automation',
          //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
          // ),
        ],
      ),
    );
  }
}
