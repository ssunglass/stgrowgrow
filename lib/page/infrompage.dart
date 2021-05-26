import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stgrowgrow/page/profile/profilepage.dart';
import 'package:stgrowgrow/page/userListWidget.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/state/searchstate.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/widgets/emptyList.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class InformPage extends StatelessWidget {
  const InformPage({Key key,this.scaffoldKey,this.refreshIndicatorKey}) : super(key: key);


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
              var searchState = Provider.of<SearchState>(context,listen: false);
              searchState.getUserDataFromDatabase();
              return Future.value(true);
            },
            child: _InFormBody(
              refreshIndicatorKey: refreshIndicatorKey,
              scaffoldKey: scaffoldKey,
            ),

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






  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context, listen:false);
    return Consumer<SearchState>(
      builder: (context,state,child) {
        final List<UserModel> list = state.getuserDetail();

        return CustomScrollView(
          slivers: <Widget>[
            child,

            Divider(
              thickness: 3,
              endIndent: 3,
              indent: 3,

            ),

            SizedBox(height: 20,),

            Divider(
              thickness: 15,
              endIndent: 15,
              indent: 15,

            ),

            SizedBox(height: 5,),

            SliverStickyHeader(
              header: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Text(
                  '다른 사람들은 지금을 \n어떻게 보내고 있을까?',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 30,

                  ),

                ),

              ),

            ),
            state.isBusy && list == null
             ? SliverToBoxAdapter(
                 child: Container(
                   height: fullHeight(context) -135,
                   child: CustomScreenLoader(
                     height: double.infinity,
                     width: fullWidth(context),
                     backgroundColor: Colors.black45,

                   ),


                 ) ,


            )
            : !state.isBusy && list ==null
               ? SliverToBoxAdapter(
                  child: EmptyList(
                    'No User have enjoyed'

                  ),



            )

               : UserListWidget(
                   list: list,
                ),

        ],


        );


      },

      child: Card(
        margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
        color: Colors.white70,
        child: InkWell(
           onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => ProfilePage(),
               ),
             );


           },

            child: Column(
             children: <Widget>[
              Text(
                authstate.profileUserModel.displayName,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold

                ) ,
              ),

              Text(
                  authstate.profileUserModel.userName,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
               Padding(
                 padding: EdgeInsets.symmetric(),
                 child: Text('내 커리어 바로가기',
                             style: const TextStyle(
                               color: Colors.black38,
                             ),
                 ),
             ),

          ],



        ),

        ),


      ),


    );




  }




}