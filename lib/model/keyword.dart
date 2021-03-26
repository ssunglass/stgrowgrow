class KeyModel{
  String keyword;




  KeyModel({


    this.keyword,


  });

  KeyModel.fromJson(Map<dynamic, dynamic> map) {
    if(map == null) {
      return;
    }

    keyword = map['keyword'];





  }
  toJson(){
    return{

      'keyword' : keyword,

    };


  }



}