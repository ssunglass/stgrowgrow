




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/theme/theme.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/widgets/title_text.dart';

class UserListWidget extends StatelessWidget {
  final List<UserModel> list;
  final String emptyScreenText;
  final String emptyScreenSubTitleText;

  UserListWidget({
    Key key,
    this.list,
    this.emptyScreenText,
    this.emptyScreenSubTitleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    String myId = state.userModel.key;
    return ListView.separated
      (itemBuilder: (context, index) {
        return UserTile(
          user: list[index],
          myId: myId,

        );


    },
        separatorBuilder: (context, index) {
        return Divider(
          height: 0,

        );
        },
        itemCount: list.length,
    );

  }

}

class UserTile extends StatelessWidget {
  const UserTile ({Key key, this.user, this.myId}) : super(key: key);
  final UserModel user;
  final String myId;

  String getSummary(String summary) {
    if(summary != null && summary.isNotEmpty && summary != 'Edit profile to update summary') {
      if (summary.length > 150) {
        summary = summary.substring(0, 150) + '...';
        return summary;
      } else {
        return summary;
      }
    }
    return null;
  }

  bool isFollowing() {
    if(user.followerList != null &&
       user.followerList.any((x) => x == myId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFollow = isFollowing();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/ProfilePage' + user?.userId);

            },
            leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/ProfilePage' + user?.userId);
              },
              child: Text('유저 프로필', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent),),

            ),
            title: Row(
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
                user.isVerified
                  ? customIcon(
                    context,
                    icon: Icons.wifi_rounded,
                  size: 15,
                  paddingIcon: 5,)
                    : SizedBox(width: 0,),
              ],
            ),

            subtitle: Text(user.userName),
            trailing: ElevatedButton(
              onPressed: () {},

              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isFollow ? 15 : 20,
                  vertical: 3,
                ),

                decoration: BoxDecoration(
                  color:
                  isFollow ? Colors.blue : Colors.white,
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Text(
                  isFollow ? 'Following' : 'Follow',
                  style: TextStyle(
                    color: isFollow ? Colors.white60 : Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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