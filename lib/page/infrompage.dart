import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stgrowgrow/page/profile/profilepage.dart';
import 'package:stgrowgrow/page/userListWidget.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/state/searchstate.dart';
import 'package:stgrowgrow/state/appstate.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';


class InformPage extends StatelessWidget {
  const InformPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

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
              var searchState =
              Provider.of<SearchState>(context, listen: false);
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
  final UserModel user;

  const _InFormBody({
    Key key,
    this.scaffoldKey,
    this.user,
    this.refreshIndicatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authstate = Provider.of<AuthState>(context,listen: false);
    var appstate = Provider.of<AppState>(
      context,
    );
    String myId = authstate.userModel.key;



    return Consumer<SearchState>(
      builder: (context, state, child) {
        final List<UserModel> list = state.getUserList(authstate.userModel);

        return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                  child: Container(
                      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                      width: 100,
                      height: 130,
                      child: Card(
                          color: Colors.white70,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
                              /*appstate.setpageIndex = 2;*/
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Padding(
                                    padding: EdgeInsets.only(top: 7, left: 7),
                                    child: Text(
                                      authstate.userModel.displayName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, left: 9),
                                    child: Text(
                                      authstate.userModel.userName,

                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 30, left: 250),
                                    child: Text(
                                      '내 커리어 바로가기',
                                      style: const TextStyle(
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ),
                                ]),
                          )))
              ),

              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: Divider(
                    thickness: 3,

                  ),

                ),
              ),

              SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amberAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                top: 20, right: 70, left: 70, bottom: 20),
                            child: Text("다른 사람들은 지금을 \n어떻게 보내고 있을까?",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ),

                            )

                        ),


                      ],
                    ),


                  ),
              ),


                SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  staggeredTileBuilder: (int index) =>
                    StaggeredTile.fit(2),
                  itemBuilder: (context, index) =>
                        UserTile(
                          user: list[index],
                          myId: myId,
                        ),


                  itemCount: list.length)


            ]
        );


      },


    );
  }
}
