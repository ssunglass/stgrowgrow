



import 'package:firebase_database/firebase_database.dart';
import 'package:stgrowgrow/state/appstate.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/model/user.dart';

class SearchState extends AppState {
  bool isBusy = false;
  SortUser sortBy = SortUser.MaxFollower;
  List<UserModel> _userFilterlist;
  List<UserModel> _userlist;


  List<UserModel> userList = [];
  List<UserModel> getuserDetail(List<String> userIds) {
    final list = _userlist.where((x) {
      if (userIds.contains(x.key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return list;
  }



}