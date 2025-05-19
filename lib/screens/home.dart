import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height * 0.5,
            width: width,
            color: Colors.black
          ),
          Container(
            width: width * 0.2,
            height: width * 0.2,
            margin: EdgeInsets.only(top: height * 0.05),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20)
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.2,
                height: width * 0.2,
                margin: EdgeInsets.only(top: height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              Container(
                width: width * 0.2,
                height: width * 0.2,
                margin: EdgeInsets.only(top: height * 0.01, left: width * 0.2),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ],
          ),
          Container(
            width: width * 0.2,
            height: width * 0.2,
            margin: EdgeInsets.only(top: height * 0.01),
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20)
            ),
          ),
        ],
      )
    );
  }
}