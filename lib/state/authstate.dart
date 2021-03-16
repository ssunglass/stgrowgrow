import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:stgrowgrow/state/appstate.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/page/signup.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;



class AuthState extends AppState{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  User user;
  String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  dabase.Query _profileQuery;

  List<UserModel> _profileUserModelList;
  UserModel _userModel;

  UserModel get userModel => _userModel;


  Future<String> signIn(String email, String password,
  {GlobalKey<ScaffoldMessengerState> scaffoldKey}) async {
    try{
      loading = true;
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      userId= user.uid;
      return user.uid;
    }catch(error) {
      loading = false;
      cprint(error, errorIn: 'signIn');
      kAnalytics.logLogin(loginMethod: 'email_login');
      customSnackBar(scaffoldKey, error.message);
      return null;
    }
  }

  Future<String> signUp(UserModel userModel,
  {GlobalKey<ScaffoldMessengerState> scaffoldKey, String password}) async {
    try{
      loading = true;
      var result =await _firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      kAnalytics.logSignUp(signUpMethod: 'register');
      result.user.updateProfile(
        displayName: userModel.displayName,);

      _userModel = userModel;
      _userModel.key = user.uid;
      _userModel.userId = user.uid;
      createUser(_userModel, newUser: true);
      return user.uid;
    }catch(error) {
      loading = false;
      cprint(error, errorIn: 'signUp');
      customSnackBar(scaffoldKey, error.message);
      return null;

    }



  }

  createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      Utility.getUserName(name: user.nickName);
      kAnalytics.logEvent(name: 'create_newUser');

      // Time at which user is created
      user.createdAt = DateTime.now().toUtc().toString();
    }

    kDatabase.child('profile').child(user.userId).set(user.toJson());
    _userModel = user;
    if (_profileUserModelList != null) {
      _profileUserModelList.last = _userModel;
    }
    loading = false;
  }


  databaseInit() {
    try{
      if(_profileQuery == null) {
        _profileQuery = kDatabase.child('profile').child(user.uid);
        _profileQuery.onValue.listen(_onProfileChanged);

      }
    } catch(error) {
      cprint(error,errorIn: 'databaseInit');
    }



  }

  void _onProfileChanged(Event event) {
    if(event.snapshot != null){
      final updateUser = UserModel.fromJson(event.snapshot.value);
      if(updateUser.userId == user.uid) {
        _userModel = updateUser;
      }
     cprint('UserModel Updated');
    notifyListeners();
    }
  }


  Future<User> getCurrentUser() async {
    try{
      loading = true;
      Utility.logEvent('get_currentUser');
      user = _firebaseAuth.currentUser;
      if (user != null) {
        authStatus = AuthStatus.LOGGED_IN;
        userId = user.uid;
        getProfileUser();
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      loading = false;
      return user;
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'getCurrentUser');
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;

    }
  }

  reloadUser() async {
    await user.reload();
    user = _firebaseAuth.currentUser;
    if(user.emailVerified) {
      userModel.isVerified = true;
      createUser(userModel);
      cprint('UserModel email verification complete');
      Utility.logEvent('email_verification_complete',
          parameter: {userModel.userName: user.email});
    }
  }

  getProfileUser({String userProfileId}) {
    try {
      loading = true;
      if (_profileUserModelList == null) {
        _profileUserModelList = [];
      }

      userProfileId = userProfileId == null ? user.uid : userProfileId;
      kDatabase
          .child("profile")
          .child(userProfileId)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            _profileUserModelList.add(UserModel.fromJson(map));
            if (userProfileId == user.uid) {
              _userModel = _profileUserModelList.last;
              _userModel.isVerified = user.emailVerified;
              if (!user.emailVerified) {
                reloadUser();
              }
              if (_userModel.fcmToken == null) {
                updateFCMToken();
              }
            }

            Utility.logEvent('get_profile');
          }
        }

        loading = false;
      });
    } catch(error) {
      loading = false;
      cprint(error, errorIn: 'getProfileUser');
    }

  }

  void updateFCMToken() {
    if(_userModel == null) {
      return;
    }
    getProfileUser();
    _firebaseMessaging.getToken().then((String token){
      assert(token != null);
      _userModel.fcmToken = token;
      createUser(_userModel);
    });


  }






}