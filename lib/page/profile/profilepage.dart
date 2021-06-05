import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'file:///D:/Androidproject/stgrowgrow/lib/page/profile/EditProfilePage.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:stgrowgrow/model/keyword.dart';
import 'package:stgrowgrow/model/bio.dart';
import 'file:///D:/Androidproject/stgrowgrow/lib/widgets/tile/biotile.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'file:///D:/Androidproject/stgrowgrow/lib/widgets/tile/keytile.dart';
import 'package:stgrowgrow/widgets/emptyList.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.profileId}) : super(key: key);

  final String profileId;


  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage>
  with SingleTickerProviderStateMixin {

  TextEditingController _keyword;
  TextEditingController _bio;
  TextEditingController _date;
  KeyModel _keyModel;


  String date;
  bool isMyProfile = false;
  int pageIndex = 0;

  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();


  @override
  void initState() {

    _keyword = TextEditingController();
    _bio = TextEditingController();
    _date = TextEditingController();
    var state = Provider.of<AuthState>(context, listen: false);

    _date.text = Utility.getdob(state?.bioModel?.date);



    WidgetsBinding.instance.addPostFrameCallback((_) {
      var authstate = Provider.of<AuthState>(context, listen: false);
      authstate.getProfileUser(userProfileId: widget.profileId);
      isMyProfile =
          widget.profileId == null || widget.profileId == authstate.userId;
    });
    super.initState();
  }

  @override
  void dispose() {
    _keyword.dispose();
    _bio.dispose();
    _date.dispose();
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

  void _keywordSubmitButton() async {

    if(_keyword.text == null || _keyword.text.isEmpty){
      return;

    }

    var state = Provider.of<AuthState>(context, listen: false);

    KeyModel keyModel = createKeyModel();


    state.createKeyword(keyModel);




    Navigator.of(context).pop();

  }

  void showYear() async {

    DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      initialDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year),

    );
    setState(() {
      if (picked != null) {
        date = picked.toString();
        _date.text = Utility.getdob(date);
      }
    });
    


  }

  void openDialog () {


  }



  KeyModel createKeyModel() {

    var authState = Provider.of<AuthState>(context,listen: false);

    KeyModel reply = KeyModel(
        keyword: _keyword.text,
        userId: authState.userModel.userId
    );

    return reply;


  }

  BioModel createBioModel() {

    BioModel reply = BioModel(
        bio: _bio.text,
       date: date,
    );

    return reply;


  }





  Widget _keyList(BuildContext context, AuthState authstate, int index,
      List<KeyModel> keyList ) {
    List<KeyModel> list;

    if (keyList == null) {

    } else {

      list = keyList.toList();

    }

    return authstate.isbusy
        ? Container(
         height: 100,
         child: CustomScreenLoader(
            height: 100,
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



        : Wrap(
           children : <Widget>[
              Keyword(
                model: list[index],
                isDisplayOnProfile: isMyProfile,
              ),


             ]


      );


  }








  Widget _bioList(BuildContext context, AuthState authstate,
      List<BioModel> bioList, ) {
    List<BioModel> list;


    if (bioList == null) {

    } else {

      list = bioList.toList();

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
            ? '바이오를 등록해주세요'
            : '${authstate.profileUserModel.userName} 바이오를 등록 해주세요' ,
      ),
    )

        : ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0),
      itemCount: list.length,

          itemBuilder: (context, index) => Container(
           color: Colors.white60,
           child:  Bio(
             model: list[index],
             isDisplayOnProfile: isMyProfile,
           )
      ),
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
    List<KeyModel> keylist;
    List<BioModel> biolist;
    int index;
    String id = widget.profileId ?? authstate.userId;

    if (authstate.keylist != null && authstate.keylist.length > 0) {
      keylist = authstate.keylist.where((x) => x.userId == id).toList();
    }



    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: Container(

              child: Column(
                children: <Widget>[
                  UserProfileWidget(
                    user: authstate.profileUserModel,
                    isMyProfile: isMyProfile
                ),

                  SizedBox(width: 3,height: 10,),

                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(Icons.add),
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
                                      onTap: _keywordSubmitButton,
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
                         ),

                  ),
                
                  _keyList(context, authstate,index,keylist),

                  SizedBox(width: 3,height: 10,)




              ],


            ),

            ),





        ),


      ),
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


  String getSummary(String summary) {
    if(isMyProfile) {
      return summary;
    } else if ( summary == 'Edit profile to update summary') {
      return 'No summary available';
    } else {
      return summary;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[


        Row(
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
            IconButton(icon: Icon(Icons.login),


            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 5, left: 9),
          child: Text(
            '${user.userName}',
          ),
        ),

       Container(
         margin: const EdgeInsets.only(left: 10, right: 100,top: 15),
         child:  Divider(
           thickness: 3,
         ),

       ),


        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
             child: Text('${user.department}'),
          ),

            Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
             child: Text('${user.major}'),
        ),

        ],

        ),

        Container(
          margin: const EdgeInsets.only(left: 10, right: 100,top: 15),
          child:  Divider(
            thickness: 3,
          ),

        ),


        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Text(getSummary(user.summary),
        ),
        ),


        Container(
          margin: const EdgeInsets.only(left: 10, right: 100,top: 15),
          child:  Divider(
            thickness: 3,
          ),

        ),




      ],



    );


  }



}