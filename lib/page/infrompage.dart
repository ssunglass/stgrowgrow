













import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:provider/provider.dart';

class InformPage extends StatefulWidget {
  InformPage({Key key,this.scaffoldKey}) : super(key: key);
  _InformPageState createState() => _InformPageState();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey;


}

class _InformPageState extends State<InformPage> {



  SliverAppBar getsliverAppbar(){

    final state = Provider.of<AuthState>(context);

    return SliverAppBar(
      expandedHeight: 150,
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

                      Text( state.userModel.displayName,)


                    ],

                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(state.userModel.userName),

                    ],
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                      Text('내 커리어 바로가기'),

                      Divider(thickness: 1,indent: 1, endIndent: 1,),

                      SizedBox(width: 3,height: 3,),

                      Divider(thickness: 5,indent: 5, endIndent: 5,),



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
          getsliverAppbar(),


          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text('다른 사람들은 지금을 \n어떻게 보내고 있을까?'),




          ),
          SliverList(







          ),



        ],



      ),



    );


  }


}