import 'package:flutter/cupertino.dart';
import 'package:stgrowgrow/page/search/SearchPage.dart';
import 'package:stgrowgrow/page/signin.dart';
import 'package:stgrowgrow/page/signup.dart';
import 'package:stgrowgrow/page/splash.dart';
import 'package:stgrowgrow/page/profile/profilepage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/page/welcome.dart';
import 'package:stgrowgrow/theme/theme.dart';
import 'package:stgrowgrow/helper/customRoute.dart';






class Routes {

  static dynamic route() {
    return{
      'SplashPage': (BuildContext context) => SplashPage(),
    };
  }


  static void sendNavigationEventToFirebase(String path) {
    if(path != null && path.isNotEmpty) {

    }

  }



  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if(pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {

      case "ProfilePage":
        String profileId;
        if (pathElements.length > 2) {
          profileId = pathElements[2];
    }
        return CustomRoute<bool>(
          builder: (BuildContext context) => ProfilePage(
             profileId: profileId,

          ));

      case "WelcomePage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => WelcomePage()
        );

      case "SignIn":
        return CustomRoute<bool>(
          builder: (BuildContext context) => SignIn()
        );

      case "SignUp":
        return CustomRoute<bool>(
          builder: (BuildContext context) => SignUp()
        );

      case "SearchPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => SearchPage()
        );






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