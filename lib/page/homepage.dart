import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/page/infrompage.dart';
import 'package:stgrowgrow/page/profilepage.dart';
import 'package:stgrowgrow/page/searchpage.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/state/appstate.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AuthState>(context, listen: false);
      state.setpageIndex = 0;
      initProfile();



    });

    super.initState();


  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();


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
        );
        break;
      case 1 :
        return SearchPage(scaffoldKey: _scaffoldKey,);
        break;
      case 2:
        return ProfilePage();
        break;
      default:
        return InformPage(scaffoldKey: _scaffoldKey);
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