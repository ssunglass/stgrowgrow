import 'dart:convert';
import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/page/welcome.dart';
import 'package:stgrowgrow/page/homepage.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:stgrowgrow/page/updateApp.dart';
import 'package:package_info/package_info.dart';
import 'package:stgrowgrow/theme/theme.dart';


class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() async {
    final isAppUpdated = await _checkAppVersion();
    if(isAppUpdated) {
      print('App is updated');
     Future.delayed(Duration(seconds: 1 )).then((_){
       var state =Provider.of<AuthState>(context, listen: false);
       state.getCurrentUser();
     });
    }
  }

  Future<bool> _checkAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentAppVersion = "${packageInfo.version}";
    final appVersion = await _getAppVersionFromFirebaseConfig();
    if (appVersion != currentAppVersion) {
      if (kDebugMode) {
        cprint("Latest version of app is not installed on your system");
        cprint(
            "In debug mode we are not restrict devlopers to redirect to update screen");
        cprint(
            "Redirect devs to update screen can put other devs in confusion");
        return true;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UpdateApp(),
        ),
      );
      return false;
    } else {
      return true;
    }
  }



  Future<String> _getAppVersionFromFirebaseConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(minutes: 1));
    await remoteConfig.activateFetched();
    var data = remoteConfig.getString('appVersion');
    if (data != null && data.isNotEmpty) {
      return jsonDecode(data)["key"];
    } else {
      cprint(
          "Please add your app's current version into Remote config in firebase",
          errorIn: "_getAppVersionFromFirebaseConfig");
      return null;
    }
  }

  Widget _body() {
    var height= 150.0;
    return Container(
      height: context.height,
      width: context.width,
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
               padding: EdgeInsets.all(50),
               decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                 Radius.circular(10),
                 ),
                   ),

          child: Stack(
            children: <Widget> [
              Platform.isIOS
              ? CupertinoActivityIndicator(
                radius: 35,

              )
                  : CircularProgressIndicator(
                strokeWidth: 2,
              ),

            ],

          ),


        )
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: state.authStatus == AuthStatus.NOT_DETERMINED
      ? _body()
      : state.authStatus == AuthStatus.NOT_LOGGED_IN
         ? WelcomePage()
         : HomePage(),

    );


  }









}