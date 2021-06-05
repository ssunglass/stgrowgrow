




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/theme/theme.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/widgets/title_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';

/* class UserListWidget extends StatelessWidget {
  final List<UserModel> list;

  UserListWidget({
    Key key,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    final _random = new Random();
    String myId = state.userModel.key;
    return SliverStaggeredGrid.countBuilder(
      itemBuilder: (context, index) =>
          Container(
            child: UserTile(
              user: list[index],
              myId: myId,
            ),

          ) ,
      itemCount: _random.nextInt(list.length),
      crossAxisCount: 2,
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2 : 1),
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
    );

  }

} */

class UserTile extends StatelessWidget {
  const UserTile ({Key key, this.user, this.myId}) : super(key: key);
  final UserModel user;
  final String myId;

  String getSummary(String summary) {
    if(summary != null && summary.isNotEmpty ) {
      if (summary.length > 150) {
        summary = summary.substring(0, 150) + '...';
        return summary;
      } else {
        return summary;
      }
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/ProfilePage' + user?.userId);

            },

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title:Row(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: 0, maxWidth: fullWidth(context) * .4),
                        child: TitleText(
                          user.displayName,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,),
                      ),
                      SizedBox(width: 5,),
                    ],
                  ),

                    subtitle: Text(user.userName),
                ),

                Divider(thickness: 3,),

                Row(
                  children: <Widget>[
                    Text(user.department),

                    Text(user.major),

                  ],

                ),

              ],

            ),

          ),

          getSummary(user.summary) == null
                ? SizedBox.shrink()
                : Padding(padding: EdgeInsets.only(left: 90),
                           child: Text(
                             getSummary(user.summary),
                           ),
          )

        ],

      ),

    );
  }

}