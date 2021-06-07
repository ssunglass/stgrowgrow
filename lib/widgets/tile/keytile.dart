





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/keyword.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/widgets/title_text.dart';
import 'package:stgrowgrow/model/user.dart';


class Keyword extends StatelessWidget{
  final KeyModel model;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final bool isDisplayOnProfile ;



   const Keyword({
    Key key,
    this.model,
    this.scaffoldKey,
     this.isDisplayOnProfile = false,

}) : super(key: key);



  void _deltedKeyword(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen:false);
    // state.deleteKeyword();

  }



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
                deleteIcon: Icon(
                  Icons.delete,
                  color: Colors.white,

                ),
                onDeleted: () {
                  _deltedKeyword(context);

                },


              ),


            ),



          ],

    ),

    ),

    ],



    );

  }







}