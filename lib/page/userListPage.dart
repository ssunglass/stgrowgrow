


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/page/userListWidget.dart';
import 'package:stgrowgrow/state/searchstate.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/widgets/title_text.dart';
import 'package:stgrowgrow/widgets/emptyList.dart';

class UserListPage extends StatelessWidget {
  UserListPage({
    Key key,
    this.pageTitle = "",
    this.emptyScreenText,
    this.emptyScreenSubTileText,
    this.appBarIcon,
    this.userIdsList,
   }) : super(key: key);

  final String pageTitle;
  final String emptyScreenText;
  final String emptyScreenSubTileText;
  final IconData appBarIcon;
  final List<String> userIdsList;


  @override
  Widget build(BuildContext context) {
    List<UserModel> userList;
    return Scaffold(
      backgroundColor: Colors.white12,

      appBar: AppBar(
        title: TitleText(pageTitle),

      ),

      body:  Consumer<SearchState>(
        builder: (context, state, child) {
          if(userIdsList != null && userIdsList.isNotEmpty) {
            userList = state.getuserDetail();
          }
          return !(userList != null && userList.isNotEmpty)
              ? Container(
                width: fullWidth(context),
                padding: EdgeInsets.only(top: 0, left: 30, right: 30),
                child: NotifyText(
                  title: emptyScreenText,
               ),
          )
              : UserListWidget(
            list: userList,

          );

        },

      ),
    );




  }
}