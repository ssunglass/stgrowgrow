import 'package:flutter/material.dart';
import 'package:stgrowgrow/page/splash.dart';




class UpdateApp extends StatefulWidget {
  const UpdateApp({Key key}) : super(key: key);

  @override
  _UpdateAppState createState() => _UpdateAppState();

}

class _UpdateAppState extends State<UpdateApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if ( state == AppLifecycleState.resumed) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Text('새로운 업데이트가 나왔습니다'),
            Text('현재 앱 버전은 더이상 지원되지 않습니다')
          ],

        ),

        ),

      );

  }
}

