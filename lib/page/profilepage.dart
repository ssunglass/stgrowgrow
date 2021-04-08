








import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/page/EditProfilePage.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/model/keyword.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/widgets/key.dart';
import 'package:stgrowgrow/widgets/emptyList.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.profileId}) : super(key: key);

  final String profileId;

  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage>
  with SingleTickerProviderStateMixin {

  TextEditingController _keyword;

  bool isMyProfile = false;
  int pageIndex = 0;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();


  @override
  void initState() {

    _keyword = TextEditingController();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      var authstate = Provider.of<AuthState>(context, listen: false);
      authstate.getProfileUser(userProfileId: widget.profileId);
      isMyProfile =
          widget.profileId == null || widget.profileId == authstate.userId;
    });
    super.initState();
  }

  void dispose() {
    _keyword.dispose();
    super.dispose();

  }

  Widget _emptyBox() {
    return SliverToBoxAdapter(child: SizedBox.shrink());
  }

  isFollower() {
    var authstate = Provider.of<AuthState>(context, listen: false);
    if (authstate.profileUserModel.followerList != null &&
        authstate.profileUserModel.followerList.isNotEmpty) {
      return (authstate.profileUserModel.followerList
          .any((x) => x == authstate.userModel.userId));
    } else {
      return false;
    }
  }

  Widget _entry(String title,
      {TextEditingController controller,
        int maxLine = 1,
        bool isenable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void _submitButton() async {
    if(_keyword.text == null || _keyword.text.isEmpty){
      return;

    }

    var state = Provider.of<AuthState>(context, listen: false);

    KeyModel keyModel = createKeyModel();


    state.createKeyword(keyModel);



    Navigator.of(context).pop();

  }

  KeyModel createKeyModel() {

    var authState = Provider.of<AuthState>(context,listen: false);

   KeyModel reply = KeyModel(
      keyword: _keyword.text,
     userId: authState.userModel.userId
    );

   return reply;


  }

  Widget _keyList(BuildContext context, AuthState authstate,
      List<KeyModel> keyList ) {
    List<KeyModel> list;

    if (keyList == null) {

    } else {

      list = keyList.toList();

    }

    return authstate.isbusy
        ? Container(
         height: fullHeight(context) - 180,
         child: CustomScreenLoader(
            height: double.infinity,
           width: fullWidth(context),
           backgroundColor: Colors.white,
      ),

    )


        : list == null || list.length < 1
        ? Container(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30),
          child: NotifyText(
           title: isMyProfile
            ? '키워드를 등록해주세요'
            : '${authstate.profileUserModel.userName} 키워드 등록을 해주세요' ,
      ),

    )





        : GridView.builder(
           padding: EdgeInsets.symmetric(vertical: 0),
           itemCount: list.length ,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
           crossAxisSpacing: 10,
             mainAxisSpacing: 10,

           ),

           itemBuilder: (context, index) => Container(
             color: Colors.white60,
             child: Keyword(
                model: list[index],
                isDisplayOnProfile: true,

            ),


         ),


      );


  }



  Widget _floatingActionButton() {
    return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _entry('keyword', controller: _keyword),
                    GestureDetector(
                      onTap: _submitButton,
                      child: Center(
                        child: Text('등록'),
                      ),
                    ),
                  ],
                ),
              ),

            ),


          );
        },
    child: Text('클릭'),


    );

  }




    Future<bool> _onWillPop() async {
      final state = Provider.of<AuthState>(context, listen: false);

      state.removeLastUser();
      return true;
    }



  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context);
    List<KeyModel> list;
    String id = widget.profileId ?? authstate.userId;

    if (authstate.keylist != null && authstate.keylist.length > 0) {
      list = authstate.keylist.where((x) => x.userId == id).toList();
    }


    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: !isMyProfile ? null : _floatingActionButton(),
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            UserProfileWidget(
                user: authstate.profileUserModel,
                isMyProfile: isMyProfile,
              ),


            ElevatedButton(
              onPressed: () {
                if (isMyProfile) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );

                } else {
                  authstate.followUser(
                    removeFollower: isFollower(),
                  );

                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isFollower()
                      ? Colors.blue
                      : Colors.white,
                  border: Border.all(
                      color: isMyProfile
                          ? Colors.black87.withAlpha(180)
                          : Colors.blue,
                      width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),

                /// If [isMyProfile] is true then Edit profile button will display
// Otherwise Follow/Following button will be display
                child: Text(
                  isMyProfile
                      ? 'Edit Profile'
                      : isFollower()
                      ? 'Following'
                      : 'Follow',
                  style: TextStyle(
                    color: isMyProfile
                        ? Colors.black87.withAlpha(180)
                        : isFollower()
                        ? Colors.white
                        : Colors.blue,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),



              ),




            ),

            SizedBox(width: 30,),

            _keyList(context, authstate, list),


          ],


        ),


    )
    );
  }

}


class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    Key key,
    @required this.user,
    @required this.isMyProfile,
}) : super(key: key);

  final bool isMyProfile;
  final UserModel user;

  String getBio(String bio) {
    if(isMyProfile) {
      return bio;
    } else if ( bio == 'Edit profile to update bio') {
      return 'no bio available';
    }else {
      return bio;
    }
  }

  String getSummary(String summary) {
    if(isMyProfile) {
      return summary;
    } else if ( summary == 'Edit profile to update summary') {
      return 'No summary available';
    } else {
      return summary;
    }
  }

  Widget _tapableText(BuildContext context, String count, String text, String navigateTo) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/$navigateTo');
      },
      child: Row(
        children: <Widget>[
          Text(
            '$count'
          ),
          Text('$text')
        ],
      ),

    );

  }




  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text('${user.displayName}'
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Text('${user.userName}'),
        ),
        Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
                height: 20,
              ),
              _tapableText(context, '${user.getFollower()}',
                  'Followers', 'FollowerListPage'),
              SizedBox(width: 40,),
              _tapableText(context, '${user.getFollowing()}',
                  'Following', 'FollowingListPage'),

            ],
          ),
        ),

        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Text(getSummary(user.summary),
        ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Text('${user.interestList}'),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Text('${user.major}'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            getBio(user.bio),
          ),
        ),

      ],



    );


  }



}