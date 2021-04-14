import 'package:flutter/material.dart';
import 'package:studily/homescreen/home_background.dart';

class HomePageBody extends StatefulWidget {
  HomePageBody({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            child: HomePageBackground(),
          ),
        )
      ],
    );
  }
}
