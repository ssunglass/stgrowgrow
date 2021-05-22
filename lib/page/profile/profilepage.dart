







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

  void _bioSubmitButton() async {
    if(_bio.text == null ||
       _bio.text.isEmpty ||
       _bio.text.length > 300) {
      return;

    }

    var state = Provider.of<AuthState>(context, listen: false);


   BioModel bioModel = createBioModel();
   state.createBio(bioModel);

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

  BioModel createBioModel() {

    BioModel reply = BioModel(
        bio: _bio.text,
       date: date,
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





        : GridView.builder(
           padding: EdgeInsets.only(top: 50, left: 30, right: 30),
           itemCount: list.length ,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
           crossAxisSpacing: 10,
             mainAxisSpacing: 10,

           ),

           itemBuilder: (context, index) => Container(
             color: Colors.white,
             child: Keyword(
                model: list[index],
                isDisplayOnProfile: true,

            ),


         ),


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
           child:  Bio()
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
    List<KeyModel> list;
    List<BioModel> biolist;
    String id = widget.profileId ?? authstate.userId;

    if (authstate.keylist != null && authstate.keylist.length > 0) {
      list = authstate.keylist.where((x) => x.userId == id).toList();
    }



    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  title: Text('${authstate.userModel.displayName}',),
                  subtitle: Text('${authstate.userModel.userName}'),
                  trailing: IconButton(
                    icon: Icon(Icons.login),
                  ) ,
                ),


              ],





            ),

          ],



        ) ,
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: NestedScrollView(

          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
           return <Widget>[
             authstate.isbusy
                 ? _emptyBox()
                 : SliverToBoxAdapter(
                   child: Container(
                   color: Colors.white,
                   child: authstate.isbusy
                     ? SizedBox.shrink()
                     : UserProfileWidget(
                   user: authstate.profileUserModel,
                   isMyProfile: isMyProfile,
                 ),
               ),
             ),
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 _keyList(context, authstate, list),
                 IconButton(
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
               ],


             ),

             Divider(
               thickness: 10,
               indent: 30,
               endIndent: 30,),
             Row(
               children: <Widget>[
                 Text('Footprint'),
                 IconButton(
                     icon: Icon(Icons.add),
                     onPressed: () {
                       showDialog(
                         context: context,
                         builder: (_) => AlertDialog(
                           content: SingleChildScrollView(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                                 InkWell(
                                   onTap: showYear,
                                   child: _entry('Year',isenable: false,controller: _date),


                                 ),
                                 _entry('Bio',controller: _bio,maxLine: null),
                                 GestureDetector(
                                   onTap: _bioSubmitButton,
                                   child: Center(
                                     child: Text('추가'),
                                   ),
                                 ),





                               ],



                             ),


                           ),
                           
                         ),


                       );
                     },)


               ],

             ),



        ];

        },

        body:Container(
          child: _bioList(context, authstate, biolist),



        ),


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

        Divider(
          height: 20,
          thickness: 3,
          indent: 20,
          endIndent: 60,
        ),

        // Container(
        //   alignment: Alignment.center,
        //   child: Row(
        //     children: <Widget>[
        //       SizedBox(
        //         width: 20,
        //         height: 20,
        //       ),
        //       //_tapableText(context, '${user.getFollower()}',
        //      //     'Followers', 'FollowerListPage'),
        //       SizedBox(width: 40,),
        //       _tapableText(context, '${user.getFollowing()}',
        //           '스크랩', 'FollowingListPage'),
        //
        //     ],
        //   ),
        // ),


        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Text('${user.department}'),
        ),

        Divider(
          height: 20,
          thickness: 3,
          indent: 20,
          endIndent: 60,
        ),

        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Text(getSummary(user.summary),
        ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Text('${user.interestList}'),
        ),



      ],



    );


  }



}