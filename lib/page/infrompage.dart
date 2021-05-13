













import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/state/searchstate.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/widgets/emptyList.dart';

class InformPage extends StatelessWidget {
  InformPage({Key key,this.scaffoldKey,this.refreshIndicatorKey}) : super(key: key);


  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: SafeArea(
        child: Container(
          height: fullHeight(context),
          width: fullWidth(context),
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              var authState = Provider.of<AuthState>(context, listen: false);
              authState.getProfileUser();
              return Future.value(true);

            },

            child: _InFormBody(),







          ),









        ),




      ),

    );



  }


}

class _InFormBody extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final List<String> userIdsList;

  const _InFormBody({Key key,
    this.scaffoldKey,
    this.refreshIndicatorKey,
    this.userIdsList}) : super(key: key);


  SliverAppBar getsliverAppbar(BuildContext context){

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
    var authstate = Provider.of<AuthState>(context, listen:false);
    List<UserModel> userList;
    final _random = new Random();
    return Consumer<SearchState>(
        builder: (context, state,child) {

          if(userIdsList != null && userIdsList.isNotEmpty) {
            userList = state.getuserDetail(userIdsList);
          }

          return !(userList != null && userList.isNotEmpty)
              ? Container(
               width: fullWidth(context),
                padding: EdgeInsets.only(top: 0, left: 30, right: 30),
                child: Text('Empty')
          )

             : CustomScrollView(
              slivers: <Widget>[

                child,

                SliverAppBar(
                  floating: true,
                  centerTitle: true,
                  title: Text('다른 사람들은 지금을 \n어떻게 보내고 있을까?'),




                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context,index) =>
                              Container(




                      ),

                      childCount: _random.nextInt(userList.length)

                  )


                ),






            ],





          );









        },



          child: getsliverAppbar(context),


        );


  }




}