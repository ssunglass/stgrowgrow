import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:stgrowgrow/model/bio.dart';
import 'package:stgrowgrow/model/keyword.dart';
import 'package:stgrowgrow/state/appstate.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';

import 'package:firebase_database/firebase_database.dart' as dabase;



class AuthState extends AppState{

  bool isBusy = false;

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  User user;
  String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  dabase.Query _profileQuery;
  dabase.Query _keyQuery;
  dabase.Query _bioQuery;

  List<KeyModel> _keylist;
  List<UserModel> _profileUserModelList;
  List<BioModel> _biolist;

  UserModel _userModel;

  UserModel get userModel => _userModel;

  UserModel get profileUserModel {
    if(_profileUserModelList != null && _profileUserModelList.length > 0) {
      return _profileUserModelList.last;
    }else {
      return null;
    }
  }

  List<KeyModel> get keylist {
    if(_keylist == null) {
      return null;
    } else {
      return List.from(_keylist.reversed);
    }

  }

  List<BioModel> get bioist {
    if(_biolist == null) {
      return null;
    } else {
      return List.from(_biolist.reversed);
    }



  }





  Future<bool> KeydatabaseInit() {
    try {
      if (_keyQuery == null) {
        _keyQuery = kDatabase.child('profile').child(user.uid).child('keyword');
        _keyQuery.onChildAdded.listen(_onKeywordAdded);
        _keyQuery.onValue.listen(_onKeywordChanged);
        _keyQuery.onChildRemoved.listen(_onKeywordRemoved);
      }

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  void getKeyDataFromDatabase(  ) {

    try {
      isBusy = true;
      _keylist = null;
      notifyListeners();
      kDatabase.child('profile').child(user.uid).child('keyword').once().then((DataSnapshot snapshot) {
        _keylist = [];
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {
              var model = KeyModel.fromJson(value);
              model.key = key;
              _keylist.add(model);

            });

          }
        } else {
          _keylist = null;
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getKeyDataFromDatabase');
    }




  }

  createKeyword(KeyModel model) {
    isBusy = true;
    notifyListeners();
    try{
      kDatabase.child('profile').child(user.uid).child('keyword').push().set(model.toJson());
    } catch (error) {
      cprint(error,errorIn: 'createKey');


    }
    isBusy = false;
    notifyListeners();
  }

  deleteKeyword() {

    try {
      kDatabase.child('profile').child(user.uid).child('keyword')
          .remove()
          .then((_) {
        cprint('Keyword deleted');
      });
    } catch (error) {
      cprint(error,errorIn: 'deletedKeyword');
    }
  }

  _onKeywordAdded(Event event) {
    KeyModel keyword = KeyModel.fromJson(event.snapshot.value);
    keyword.key = event.snapshot.key;


    keyword.key = event.snapshot.key;
    if (_keylist == null) {
      _keylist = [];
    }
    if (_keylist.length == 0 || _keylist.any((x) => x.key != keyword.key)
    ) {
      _keylist.add(keyword);
      cprint('Keyword Added');
    }
    isBusy = false;
    notifyListeners();
  }

  _onKeywordChanged(Event event) {
    var model = KeyModel.fromJson(event.snapshot.value);
    model.key = event.snapshot.key;
    if (_keylist.any((x) => x.key == model.key)) {
      var oldEntry = _keylist.lastWhere((entry) {
        return entry.key == event.snapshot.key;
      });
      _keylist[_keylist.indexOf(oldEntry)] = model;
    }


    if (event.snapshot != null) {
      cprint('Keyword updated');
      isBusy = false;
      notifyListeners();
    }



  }


   _onKeywordRemoved(Event event) async {
    KeyModel keyword = KeyModel.fromJson(event.snapshot.value);
    keyword.key = event.snapshot.key;

    try{
      KeyModel deletedKeyword;
      if(_keylist.any((x) => x.key == keyword.key)) {
        deletedKeyword = _keylist.firstWhere((x) => x.key == keyword.key);
        _keylist.remove(deletedKeyword);
      }

      if(_keylist.length == 0) {
        _keylist = null;
      }
      cprint('Keyword deleted');

    } catch (error) {
      cprint(error, errorIn: '_onKeywordRemoved');
    }



  }


  Future<bool> BiodatabaseInit() {

    try {
      if (_bioQuery == null) {
        _bioQuery = kDatabase.child('profile').child(user.uid).child('bio');
        _bioQuery.onChildAdded.listen(_onBioAdded);
        _bioQuery.onValue.listen(_onBioChanged);
        _bioQuery.onChildRemoved.listen(_onBioRemoved);
      }

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  void getBioDataFromDatabase(  ) {

    try {
      isBusy = true;
      _biolist = null;
      notifyListeners();
      kDatabase.child('profile').child(user.uid).child('bio').once().then((DataSnapshot snapshot) {
        _biolist = [];
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {
              var model = BioModel.fromJson(value);
              model.key = key;
              _biolist.add(model);

            });

          }
        } else {
          _biolist = null;
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getBioDataFromDatabase');
    }




  }


   createBio(BioModel model) {
    isBusy = true;
    notifyListeners();
    try {
      kDatabase.child('profile').child(user.uid).child('bio').push().set(model.toJson());
    } catch(error) {
      cprint(error,errorIn: 'createBio');
    }
    isBusy = false;
    notifyListeners();
  }

  deleteBio() {

    try {
      kDatabase.child('profile').child(user.uid).child('bio')
          .remove()
          .then((_) {
        cprint('Bio deleted');
      });
    } catch (error) {
      cprint(error,errorIn: 'deletedBio');
    }
  }

  _onBioAdded(Event event) {
    BioModel bio = BioModel.fromJson(event.snapshot.value);
    bio.key = event.snapshot.key;


    bio.key = event.snapshot.key;
    if (_biolist == null) {
      _biolist = [];
    }
    if (_biolist.length == 0 || _biolist.any((x) => x.key != bio.key)
    ) {
      _biolist.add(bio);
      cprint('bio Added');
    }
    isBusy = false;
    notifyListeners();
  }

  _onBioChanged(Event event) {
    var model = BioModel.fromJson(event.snapshot.value);
    model.key = event.snapshot.key;
    if (_biolist.any((x) => x.key == model.key)) {
      var oldEntry = _biolist.lastWhere((entry) {
        return entry.key == event.snapshot.key;
      });
      _biolist[_biolist.indexOf(oldEntry)] = model;
    }


    if (event.snapshot != null) {
      cprint('Bio updated');
      isBusy = false;
      notifyListeners();
    }



  }

  _onBioRemoved(Event event) async {
    BioModel bio = BioModel.fromJson(event.snapshot.value);
    bio.key = event.snapshot.key;

    try{
      BioModel deletedKeyword;
      if(_biolist.any((x) => x.key == bio.key)) {
        deletedKeyword = _biolist.firstWhere((x) => x.key == bio.key);
        _biolist.remove(deletedKeyword);
      }

      if(_biolist.length == 0) {
        _biolist = null;
      }
      cprint('Bio deleted');

    } catch (error) {
      cprint(error, errorIn: '_onBioRemoved');
    }



  }





  void removeLastUser() {
    _profileUserModelList.removeLast();

  }



  Future<String> signIn(String email, String password,
  {GlobalKey<ScaffoldMessengerState> scaffoldKey}) async {
    try{
      loading = true;
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      userId= user.uid;
      return user.uid;
    } catch(error) {
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
    if (newUser) {user.userName=
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

 // Future<void> updateUserProfile(UserModel userModel,
 //     ) async {
 //   try {
 //       if (userModel != null) {
 //         kDatabase.child('profile').child(user.uid).update(userModel.toJson());
 //       } else {
 //         kDatabase.child('profile').child(user.uid).update(_userModel.toJson());
 //       }

//      Utility.logEvent('update_user');
 //   } catch (error) {
 //     cprint(error, errorIn: 'updateUserProfile');
 //  }
 // }




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





  followUser({bool removeFollower = false}) {
    try {
      if (removeFollower) {

        profileUserModel.followerList.remove(userModel.userId);


        userModel.followingList.remove(profileUserModel.userId);
        cprint('user removed from following list', event: 'remove_follow');
      } else {

        if (profileUserModel.followerList == null) {
          profileUserModel.followerList = [];
        }
        profileUserModel.followerList.add(userModel.userId);
        // Adding profile user to logged-in user's following list
        if (userModel.followingList == null) {
          userModel.followingList = [];
        }
        userModel.followingList.add(profileUserModel.userId);
      }
      // update profile user's user follower count
      profileUserModel.followers = profileUserModel.followerList.length;
      // update logged-in user's following count
      userModel.following = userModel.followingList.length;
      kDatabase
          .child('profile')
          .child(profileUserModel.userId)
          .child('followerList')
          .set(profileUserModel.followerList);
      kDatabase
          .child('profile')
          .child(userModel.userId)
          .child('followingList')
          .set(userModel.followingList);
      cprint('user added to following list', event: 'add_follow');
      notifyListeners();
    } catch (error) {
      cprint(error, errorIn: 'followUser');
    }
  }








}