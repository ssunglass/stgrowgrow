




class BioModel {
String key;
String date;
String bio;


BioModel({
  this.key,
  this.date,
  this.bio,


});






BioModel.fromJson(Map<dynamic, dynamic> map) {

    key = map['key'];
    date = map['date'];
    bio = map['bio'];







  }

  toJson() {

    return {

      'key': key,
      'date' : date,
      'bio' : bio,


    };
  }





}