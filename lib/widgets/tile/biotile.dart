



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/bio.dart';

class Bio extends StatelessWidget{

  final BioModel model;
  final bool isDisplayOnProfile;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  const Bio({
    Key key,
    this.model,
    this.isDisplayOnProfile = false,
    this.scaffoldKey,

  }) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        VerticalDivider(
          thickness: 2,
          width: 2,
          color: Colors.white70,
          indent: 5,
          endIndent: 5,),
        Text(model.date
        ),
        Text(model.bio),
        VerticalDivider(thickness: 2,
          width: 2,
          color: Colors.white70,
          indent: 5,
          endIndent: 5,),

      ],



    );



  }



}