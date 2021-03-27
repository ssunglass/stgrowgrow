





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/model/keyword.dart';

class Keyword extends StatelessWidget{
  final KeyModel model;
  final bool isDisplayOnProfile;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  const Keyword({
    Key key,
    this.model,
    this.isDisplayOnProfile = false,
    this.scaffoldKey,

}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget> [
      InkWell(
        child: Column(
          children:<Widget>[
            Container(
              child:InputChip(
               label: Text(model.keyword),
                labelStyle: TextStyle(color: Colors.white),

              ),


            ),



          ],

    ),

    ),

    ],



    );

  }







}