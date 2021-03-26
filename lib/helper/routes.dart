import 'package:flutter/cupertino.dart';
import 'package:stgrowgrow/page/splash.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';






class Routes {

  static dynamic route() {
    return{
      'SplashPage': (BuildContext context) => SplashPage(),
    };
  }




  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if(pathElements[0] != '' || pathElements.length ==1) {
      return null;
    }
    switch(pathElements[1]) {



      default:
        return onUnknowRoute(RouteSettings(name:'/Feature'));
    }

  }

  static Route onUnknowRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(
        title: Text('${settings.name.split('/')[1]}'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('${settings.name.split('/')[1]} Coming soon..'),
      ),
    )
    );
  }

}