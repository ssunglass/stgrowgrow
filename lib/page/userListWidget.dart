




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/page/profile/profilepage.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/state/authstate.dart';



class UserTile extends StatelessWidget {
  const UserTile ({Key key, this.user, this.scaffoldKey}) : super(key: key);
  final UserModel user;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

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
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context, ProfilePage.getRoute(profileId: user.userId));
            },

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 7,left: 7),
                  child: Text(
                    user.displayName,
                    style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold

                    ) ,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 9),
                  child: Text(
                    '${user.userName}',
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 10, right: 100,top: 5),
                  child:  Divider(
                    thickness: 3,
                  ),

                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Text("${user.department} 계열"),
                    ),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Text('${user.major} 재학'),
                    ),

                  ],

                ),

               SizedBox(
                 height: 5,
               ),

               getSummary(user.summary) == null
                ? SizedBox.shrink()
                     : Padding(padding: EdgeInsets.only(left: 5, bottom: 10),
                    child: Text(
                          getSummary(user.summary),
                           ),
                              ),



              ],

            ),
    ),

          ]


          )


    );
  }

}