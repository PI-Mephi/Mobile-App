import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: MediaQuery.of(context).orientation == Orientation.portrait ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height * 0.5,
            width: width,
            child: Center(
              child: Mjpeg(
                stream: "http://192.168.251.248:81/stream",
                isLive: true,
                width: width,
                height: height * 0.5,
                fit: BoxFit.cover,
              )
            ),
          ),
          Container(
            height: height * 0.2,
            child: Text("Text"),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_drop_up, size: width * 0.15, color: Colors.white,),
            style: IconButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: BeveledRectangleBorder(),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_left, size: width * 0.15, color: Colors.white,),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: BeveledRectangleBorder(),
                ),
              ),
              SizedBox(
                width: width * 0.2,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_right, size: width * 0.15, color: Colors.white,),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: BeveledRectangleBorder(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_drop_down, size: width * 0.15, color: Colors.white,),
            style: IconButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: BeveledRectangleBorder(),
            ),
          ),
        ],
      ) : Column(
        children: [
          Row(
            children: [
              Container(
                width: width * 0.15,
                color: Colors.grey.withOpacity(0.2),
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_drop_up, size: width * 0.1, color: Colors.white,),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: BeveledRectangleBorder(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_drop_down, size: width * 0.1, color: Colors.white,),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: BeveledRectangleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width * 0.7,
                height: height,
                child: Column(
                  children: [
                    Container(
                      width: width * 0.7,
                      height: height * 0.8,
                      color: Colors.black,
                      child: Center(
                          child: Mjpeg(
                            stream: "http://192.168.4.2:81/stream", 
                            isLive: true,
                            width: width * 0.7,
                            height: height * 0.8,
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    Container(
                      child: Text('Text'),
                    )
                  ],
                ),
              ),
              Container(
                width: width * 0.15,
                color: Colors.grey.withOpacity(0.2),
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_drop_up, size: width * 0.1, color: Colors.white,),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: BeveledRectangleBorder(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_drop_down, size: width * 0.1, color: Colors.white,),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: BeveledRectangleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}