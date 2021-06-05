import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/routes.dart';
import 'package:stgrowgrow/state/appstate.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/state/searchstate.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),

      ],
      child: MaterialApp(
        title: "커커",
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknowRoute(settings),
        initialRoute: "SplashPage",
      ),
    );
  }
}
