import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:stgrowgrow/helper/enum.dart';



class AuthState extends AppState{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

}