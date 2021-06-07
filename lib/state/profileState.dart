

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_database/firebase_database.dart';


class ProfileState extends ChangeNotifier {
  ProfileState(this.profileId) {
    databaseInit();
    userId = FirebaseAuth.instance.currentUser.uid;
    _getLoggedInUserProfile(userId);
    _getProfileUser(profileId);
  }


  String userId;

  UserModel _userModel;
  UserModel get userModel => _userModel;


  dabase.Query _profileQuery;
  StreamSubscription<Event> profileSubscription;


  final String profileId;

  UserModel _profileUserModel;
  UserModel get profileUserModel => _profileUserModel;

  bool _isBusy = true;
  bool get isbusy => _isBusy;
  set loading(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  databaseInit() {
    try{
      if(_profileQuery == null) {
        _profileQuery = kDatabase.child("profile").child(profileId);
        profileSubscription = _profileQuery.onValue.listen(_onProfileChanged);


      }

    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
    }

  }

  bool get isMyProfile => profileId == userId;

  void _getLoggedInUserProfile(String userId) async {
    kDatabase
          .child("profile")
          .child(userId)
          .once()
          .then((DataSnapshot snapshot) {
        if(snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            _userModel = UserModel.fromJson(map);
          }
        }

    } );
  }

  void _getProfileUser(String userProfileId) {
    assert(userProfileId != null);
    try{
      loading = true;
      kDatabase
           .child("profile")
           .child(userProfileId)
           .once()
           .then((DataSnapshot snapshot) {
             if(snapshot.value != null) {
               var map = snapshot.value;
               if(map != null) {
                 _profileUserModel = UserModel.fromJson(map);
                 Utility.logEvent('get_profile');
               }


             }

             loading = false;

      } );


    } catch(error) {
      loading = false;
      cprint(error, errorIn: 'getProfileUser');

    }
  }

  void _onProfileChanged(Event event) {
    if(event.snapshot != null) {
      final updateUser = UserModel.fromJson(event.snapshot.value);
      if(updateUser.userId == profileId) {
        _profileUserModel = updateUser;
      }
      notifyListeners();
    }
  }

  @override
  void dispose(){
    _profileQuery.onValue.drain();
    profileSubscription.cancel();
    super.dispose();

  }








}