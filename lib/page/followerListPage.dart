



import 'package:flutter/material.dart';
import 'package:stgrowgrow/page/userListPage.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:provider/provider.dart';







class FollowerListPage extends StatelessWidget {
  FollowerListPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, );
    return UserListPage(
      pageTitle: 'Followers',
      userIdsList: state.profileUserModel?.followerList,
      appBarIcon: Icons.add,
      emptyScreenText:
      '${state?.profileUserModel?.userName ?? state.userModel.userName} doesn\'t have any followers',
      emptyScreenSubTileText:
      'When someone follow them, they\'ll be listed here.',

    );

  }


}