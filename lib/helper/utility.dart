import 'dart:async';


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';








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

  static String getPostTime2(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat =
        DateFormat.jm().format(dt) + ' - ' + DateFormat("dd MMM yy").format(dt);
    return dat;
  }

  static String getdob(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat = DateFormat.y().format(dt);
    return dat;
  }

  static String getJoiningDate(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat = DateFormat("MMMM yyyy").format(dt);
    return 'Joined $dat';
  }

  static String getPollTime(String date) {
    int hr, mm;
    String msg = 'Poll ended';
    var enddate = DateTime.parse(date);
    if (DateTime.now().isAfter(enddate)) {
      return msg;
    }
    msg = 'Poll ended in';
    var dur = enddate.difference(DateTime.now());
    hr = dur.inHours - dur.inDays * 24;
    mm = dur.inMinutes - (dur.inHours * 60);
    if (dur.inDays > 0) {
      msg = ' ' + dur.inDays.toString() + (dur.inDays > 1 ? ' Days ' : ' Day');
    }
    if (hr > 0) {
      msg += ' ' + hr.toString() + ' hour';
    }
    if (mm > 0) {
      msg += ' ' + mm.toString() + ' min';
    }
    return (dur.inDays).toString() +
        ' Days ' +
        ' ' +
        hr.toString() +
        ' Hours ' +
        mm.toString() +
        ' min';
  }

  static String getSocialLinks(String url) {
    if (url != null && url.isNotEmpty) {
      url = url.contains("https://www") || url.contains("http://www")
          ? url
          : url.contains("www") &&
          (!url.contains('https') && !url.contains('http'))
          ? 'https://' + url
          : 'https://www.' + url;
    } else {
      return null;
    }
    cprint('Launching URL : $url');
    return url;
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      cprint('Could not launch $url');
    }
  }



  static void logEvent(String event, {Map<String, dynamic> parameter}) {
    kReleaseMode
        ? kAnalytics.logEvent(name: event, parameters: parameter)
        : print("[EVENT]: $event");
  }

  static void debugLog(String log, {dynamic param = ""}) {
    final String time = DateFormat("mm:ss:mmm").format(DateTime.now());
    print("[$time][Log]: $log, $param");
  }

  static void share(String message, {String subject}) {
    Share.share(message, subject: subject);
  }

  static List<String> getHashTags(String text) {
    RegExp reg = RegExp(
        r"([#])\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> _matches = reg.allMatches(text);
    List<String> resultMatches = List<String>();
    for (Match match in _matches) {
      if (match.group(0).isNotEmpty) {
        var tag = match.group(0);
        resultMatches.add(tag);
      }
    }
    return resultMatches;
  }

  static String getUserName({
    String name,
  }) {
    String userName = '';
    userName = '@$name';
    return userName;
  }


  static bool validateCredentials(
      GlobalKey<ScaffoldMessengerState> _scaffoldKey, String email, String password) {
    if (email == null || email.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please enter email id');
      return false;
    } else if (password == null || password.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please enter password');
      return false;
    }

    var status = validateEmail(email);
    if (!status) {
      customSnackBar(_scaffoldKey, 'Please enter valid email id');
      return false;
    }
    return true;
  }

  static customSnackBar(GlobalKey<ScaffoldMessengerState> _scaffoldKey, String msg,
      {double height = 30, Color backgroundColor = Colors.black}) {
    if (_scaffoldKey == null || _scaffoldKey.currentState == null) {
      return;
    }
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  static bool validateEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    var status = regExp.hasMatch(email);
    return status;
  }




  static void copyToClipBoard({
    GlobalKey<ScaffoldMessengerState> scaffoldKey,
    String text,
    String message,
  }) {
    assert(message != null);
    assert(text != null);
    var data = ClipboardData(text: text);
    Clipboard.setData(data);
    customSnackBar(scaffoldKey, message);
  }





}
