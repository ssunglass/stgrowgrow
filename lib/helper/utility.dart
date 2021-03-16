import 'dart:async';


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';






final kAnalytics = FirebaseAnalytics();
final DatabaseReference kDatabase = FirebaseDatabase.instance.reference();
final kScreenLoader = CustomLoader();
void cprint(dynamic data, {String errorIn, String event}) {
  if(kDebugMode) {
    if(errorIn != null) {
      print(
          '****************************** error ******************************'
      );
      developer.log('[Error]',
          time: DateTime.now(), error: data, name: errorIn);
      print( '****************************** error ******************************');
    } else if( data != null){
      developer.log(data, time: DateTime.now(),
      );
    }
    if (event != null) {
     Utility.logEvent(event);
    }
  }
}

class Utility {

  static void logEvent(String event, {Map<String, dynamic> parameter}) {
    kReleaseMode
        ? kAnalytics.logEvent(name: event, parameters: parameter)
        : print("[EVENT]: $event");
  }

  static bool validateCrendentials(
      GlobalKey<ScaffoldMessengerState> _scaffoldKey, String email,
      String password) {
    if (email == null || email.isEmpty) {
      customSnackBar(_scaffoldKey, '이메일을 입력해주세요');
      return false;
    } else if (password == null || password.isEmpty) {
      customSnackBar(_scaffoldKey, '비밀번호를 입력해주세요');
      return false;
    }
  }

  static String getUserName({
    String name,
  }) {
    String userName = '';
    userName = '@$name';
    return userName;
  }

}
