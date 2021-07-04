import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/model/keyword.dart';
import 'package:stgrowgrow/model/bio.dart';
import 'package:stgrowgrow/state/profileState.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/theme/theme.dart';
import 'package:stgrowgrow/widgets/emptyList.dart';
import 'package:stgrowgrow/widgets/tile/keytile.dart';
import 'package:stgrowgrow/widgets/tile/biotile.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.profileId}) : super(key: key);

  final String profileId;
  static MaterialPageRoute getRoute({String profileId}) {
    return new MaterialPageRoute(
      builder: (_) => Provider(
          create: (_) => ProfileState(profileId),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => ProfileState(profileId),
            builder: (_, child) => ProfilePage(
              profileId: profileId,
            ),

          ),)



    );

  }



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
      var profilestate = Provider.of<ProfileState>(context, listen: false);

      isMyProfile = profilestate.isMyProfile;
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

  void showYear()  {
    final year = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height /4.0 ,
            width: MediaQuery.of(context).size.width,
            child: YearPicker(
              selectedDate: DateTime.now(),
              firstDate: DateTime(year - 20),
              lastDate:DateTime.now() ,
              onChanged: (value) {
                date = value.toString();
                _date.text = Utility.getdob(date);
                Navigator.of(context).pop();
              },


            ),


          ),


        );

      }


    );



    /* DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1980),
      initialDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year),

    );
    setState(() {
      if (picked != null) {
        date = picked.toString();
        _date.text = Utility.getdob(date);
      }
    }); */
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
           width: context.width,
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
           children: list.map(
                   (item) => Keyword(model: item,)
           ).toList().cast<Widget>(),


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
      height: context.height - 180,
           child: CustomScreenLoader(
            height: double.infinity,
           width: context.width,
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
      return true;
    }



  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context);
    var profilestate = Provider.of<ProfileState>(context);
    List<KeyModel> keylist;
    List<BioModel> biolist;
    String id = widget.profileId ?? authstate.userId;

    if (authstate.keylist != null && authstate.keylist.length > 0) {
      keylist = authstate.keylist.where((x) => x.userId == id).toList();
    }

    if (authstate.biolist != null && authstate.biolist.length > 0) {
      biolist = authstate.biolist.where((x) => x.userId == id).toList();
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
                  SizedBox(height: 5,),

                  UserProfileWidget(
                    user: profilestate.profileUserModel,
                    isMyProfile: isMyProfile
                ),



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
                
                    _keyList(context, authstate,  keylist),

                  Container(
                    margin: const EdgeInsets.only(left: 170, right: 170,top: 15),
                    child:  Divider(
                      thickness: 10,
                      color: Colors.black,
                    ),

                  ),


                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child:Text('Footprint'),
                      ),


                      Container(
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
                                 InkWell(
                                   onTap: showYear,
                                   child: _entry('Year', isenable: false, controller: _date),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(16.0),
                                   child: TextField(
                                     decoration: InputDecoration(
                                         border: OutlineInputBorder(), labelText: "Description"),
                                     maxLines: 10,
                                     controller: _bio,
                                   ),
                                 ),
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

                    ],

                  ),







                  // _bioList(context, authstate, biolist),









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

        Container(
          child:Padding(
          padding: EdgeInsets.only(top: 5, left: 9),
          child: Text(
            '${user.userName}',
          ),
        ),
    ),

       Container(
         margin: const EdgeInsets.only(left: 10, right: 150,top: 10),
         child:  Divider(
           thickness: 3,
         ),

       ),

           Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
             child: Text('${user.department}계열, ${user.major} 재학'),
          ),


        Container(
          margin: const EdgeInsets.only(left: 10, right: 150,top: 10),
          child:  Divider(
            thickness: 3,
          ),

        ),


        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Text(getSummary(user.summary),
        ),
        ),


        Container(
          margin: const EdgeInsets.only(left: 10, right: 150,top: 10),
          child:  Divider(
            thickness: 3,
          ),

        ),






      ],



    );


  }



}