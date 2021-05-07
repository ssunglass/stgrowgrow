




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/page/userListPage.dart';
import 'package:stgrowgrow/state/authstate.dart';

class FollowingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return UserListPage(
      pageTitle: 'Following',
      userIdsList: state.profileUserModel.followingList,
      appBarIcon: Icons.add,
        emptyScreenText:
        '${state?.profileUserModel?.userName ?? state.userModel.userName} isn\'t follow anyone',
        emptyScreenSubTileText: 'When they do they\'ll be listed here.'
    );

  }

}