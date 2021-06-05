import 'package:flutter/material.dart';
import 'package:stgrowgrow/helper/routes.dart';


 class CustomRoute<T> extends MaterialPageRoute<T> {
   CustomRoute({WidgetBuilder builder, RouteSettings settings})
       : super(builder: builder, settings: settings);


   @override
   Widget buildTransitions(BuildContext context, Animation<double> animation,
       Animation<double> secondaryAnimation, Widget child) {
     Routes.sendNavigationEventToFirebase(settings.name);
     if (settings.name == "SplashPage") {
       return child;
     }
     return FadeTransition(
         opacity: CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
         child: child,
     );
   }

 }

