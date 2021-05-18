



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/model/user.dart';

class UserTile extends StatelessWidget {

  const UserTile ({Key key, this.model, this.myId}) : super(key: key);
  final UserModel model;
  final String myId;




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('ProfilePage');
          },

          child: Container(

            child: Column(

              children: <Widget>[
                    Text(model.displayName),

                    Text(model.userName),

                    Text(model.major),

                    Text(model.summary),



                  ],

    ),






            ),




          ),



      ],



    );


  }
}





