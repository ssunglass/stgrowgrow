import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/page/infrompage.dart';
import 'file:///D:/Androidproject/stgrowgrow/lib/page/profile/profilepage.dart';
import 'package:stgrowgrow/page/search/SearchPage.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/state/appstate.dart';
import 'package:stgrowgrow/state/searchstate.dart';
import 'package:stgrowgrow/model/user.dart';
import 'file:///D:/Androidproject/stgrowgrow/lib/widgets/bottomMenuBar/bottomMenuBar.dart';








class HomePage extends StatefulWidget{
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();
  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;

  @override
  void initState(  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setpageIndex = 0;
      initProfile();
      initKeyword();
      initBio();
      initSearch();




    });

    super.initState();


  }

  @override
  void dispose() {

    super.dispose();
  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();


  }

  void initKeyword() {
    var state = Provider.of<AuthState>(context,listen: false);
    state.KeydatabaseInit();
    state.getKeyDataFromDatabase();



  }

  void initBio() {
    var state = Provider.of<AuthState>(context,listen: false);
    state.BiodatabaseInit();
    state.getBioDataFromDatabase();

  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context,listen: false);
    searchState.getKeyDataFromDatabase();
    searchState.getUserDataFromDatabase();

  }


  Widget _body() {

    return SafeArea(
        child: Container(
          child: _getPage(Provider.of<AppState>(context).pageIndex),
        ),
    );


  }

  Widget _getPage(int index) {
    switch(index) {
      case 0 :
        return InformPage(
         scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
        break;
      case 1 :
        return SearchPage(scaffoldKey: _scaffoldKey,);
        break;
      case 2:
        return ProfilePage();
        break;
      default:
        return InformPage(
            scaffoldKey: _scaffoldKey);
        break;
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomMenubar(),
      body: _body(),

    );
  }



}