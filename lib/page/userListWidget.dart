




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/page/profile/profilepage.dart';






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
              Navigator.push(
                 context, ProfilePage.getRoute(profileId: user.userId)
              );

            },

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


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