


import 'package:stgrowgrow/model/user.dart';

class KeyModel{
  String keyword;
  String userId;
  String key;
  UserModel user;




  KeyModel({
    this.key,


    this.keyword,
    this.userId,
    this.user,


  });

  KeyModel.fromJson(Map<dynamic, dynamic> map) {

    keyword = map['keyword'];
    userId = map['userId'];
    key = map['key'];
    user = UserModel.fromJson(map['user']);






  }
  toJson(){
    return{

      'key' : key,
      'keyword' : keyword,
      "userId": userId,
      "user": user == null ? null : user.toJson(),

    };


  }



}