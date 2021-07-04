




class BioModel {
String key;
String userId;
String date;
String bio;


BioModel({
  this.key,
  this.userId,
  this.date,
  this.bio,


});






BioModel.fromJson(Map<dynamic, dynamic> map) {

    key = map['key'];
    userId = map['userId'];
    date = map['date'];
    bio = map['bio'];







  }

  toJson() {

    return {

      'key': key,
      'date' : date,
      'userId' : userId,
      'bio' : bio,


    };
  }





}