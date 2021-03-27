import 'package:stgrowgrow/model/user.dart';


class KeyModel{
  String keyword;
  UserModel user;
  String userId;




  KeyModel({


    this.keyword,
    this.user,
    this.userId,


  });

  KeyModel.fromJson(Map<dynamic, dynamic> map) {
    if(map == null) {
      return;
    }

    keyword = map['keyword'];
    user = UserModel.fromJson(map['user']);
    userId = map['userId'];






  }
  toJson(){
    return{

      'keyword' : keyword,
      "user": user == null ? null : user.toJson(),
      "userId": userId,

    };


  }



}