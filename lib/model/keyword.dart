


class KeyModel{
  String keyword;
  String userId;
  String key;




  KeyModel({
    this.key,


    this.keyword,
    this.userId,


  });

  KeyModel.fromJson(Map<dynamic, dynamic> map) {

    keyword = map['keyword'];
    userId = map['userId'];
    key = map['key'];






  }
  toJson(){
    return{

      'key' : key,
      'keyword' : keyword,
      "userId": userId,

    };


  }



}