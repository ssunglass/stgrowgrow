













import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformPage extends StatefulWidget {
  InformPage({Key key,this.scaffoldKey}) : super(key: key);
  _InformPageState createState() => _InformPageState();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey;


}

class _InformPageState extends State<InformPage> {


  SliverAppBar sliverAppbar(){
    return SliverAppBar(
      expandedHeight: 150,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('ProfilePage');
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 180,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
              child: Stack(
                children: <Widget>[
              Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                    ],

                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                    ],
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                    ],

                  ),

                ],



              ),
              ),


                ],

              ),

            ),

          ),


        ),





      ),


    );


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers:  [
          sliverAppbar(),

        ],



      ),



    );


  }


}