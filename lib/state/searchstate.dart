

import 'package:firebase_auth/firebase_auth.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:stgrowgrow/state/appstate.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/model/keyword.dart';

class SearchState extends AppState {
  bool isBusy = false;




  List<KeyModel> _keylist;
  List<KeyModel> _keyFilterlist;
  List<KeyModel> keyList = [];

  List<KeyModel> get keylist {
    if(_keylist == null) {
      return null;

    } else {
      return List.from(_keylist);
    }
  }



  List<UserModel> _userlist;

  List<UserModel> get userList {
    if(_userlist == null) {
      return null;

    } else {
      return List.from(_userlist.reversed);
    }



  }

  List<UserModel> getUserList (UserModel userModel) {
    if (userModel == null ) {
      return null;
    }

    List<UserModel> list;

    if(!isBusy && userList != null && userList.isNotEmpty) {
      list = userList.toList();

      if (list.isEmpty) {
        list = null;
      }
    }
    return list;


  }





  List<KeyModel> getkeyDetail(List<String> keyIds) {
    final list = _keylist.where((x) {
      if (keyIds.contains(x.key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return list;
  }


  void getUserDataFromDatabase() {
    try {
      isBusy = true;
      kDatabase.child('profile').once().then(
              (DataSnapshot snapshot) {
                _userlist = [];
                if(snapshot.value != null) {
                  var map = snapshot.value;
                  if(map != null) {
                    map.forEach((key,value) {
                      var model = UserModel.fromJson(value);
                      model.key = key;
                      _userlist.add(model);
                    });

                  }

                } else {
                  _userlist = null;


                }
                isBusy = false;



              },
      );
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getUserDataFromDatabase');

    }
  }







  void getKeyDataFromDatabase() {
    try {
      isBusy = true;
      kDatabase.child('profile').once().then(
            (DataSnapshot snapshot) {
              _keylist = [];
              _keyFilterlist = [];
          if (snapshot.value != null) {
            var map = snapshot.value;
            if (map != null) {
              map.forEach((key, value) {
                var keymodel = KeyModel.fromJson(value);
                keymodel.key = key;
                _keylist.add(keymodel);
                _keyFilterlist.add(keymodel);
              });

              _keyFilterlist
                  .sort((x,y) => y.keyword.compareTo(x.keyword));
            }
          } else {
            _keylist = null;
          }
          isBusy = false;
        },
      );
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getKeyDataFromDatabase');
    }
  }


  void resetFilterList() {
    if (_keylist != null && _keylist.length != _keyFilterlist.length)  {

      _keyFilterlist = List.from(_keylist);
      _keyFilterlist.sort((x,y) => y.keyword.compareTo(x.keyword));
      notifyListeners();


    }
  }


  void filterBy(String keyword) {
    if (keyword.isEmpty &&
            _keylist != null &&
            _keylist.length != _keyFilterlist.length) {
      _keyFilterlist = List.from(_keylist);
    }

    if(_keylist == null && _keylist.isEmpty) {
      print("Empty keyList");
      return;
    }

    // sortBy userlist on the basis of username
     else if( keyword != null ) {
      _keyFilterlist = _keylist
          .where((x) =>
      x.keyword != null &&
          x.keyword.trim().contains(keyword.trim())
      ).toList();
    }


    notifyListeners();
  }







}



