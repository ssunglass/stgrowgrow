













import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformPage extends StatefulWidget {
  InformPage({Key key,this.scaffoldKey}) : super(key: key);
  _InformPageState createState() => _InformPageState();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey;


}

class _InformPageState extends State<InformPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('준비중', style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
        ),
        ),


      ),



    );


  }


}