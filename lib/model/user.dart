class UserModel{
  String key;
  String email;
  String userId;
  String displayName;
  String userName;
  String nickName;

  String summary;
  String bio;


  bool isVerified;


  String createdAt;
  String fcmToken;




  UserModel({
  this.email,
  this.userId,
  this.key,
  this.displayName,
  this.userName,
    this.nickName,
    this.summary,
    this.bio,

    this.createdAt,
  this.isVerified,
  this.fcmToken,





});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if(map == null) {
      return;
    }
    email = map['email'];
    userId = map ['userId'];
    key = map['key'];
    displayName = map['displayName'];
    userName = map['userName'];
    nickName = map['nickName'];
    summary = map['summary'];
    bio = map['bio'];



    createdAt = map['createdAt'];
    fcmToken = map['fcmToken'];
    isVerified = map['isVerified'] ?? false;





  }
  toJson(){
    return{
      'key' : key,
      'userId' : userId,
      'email' : email,
      'displayName' : displayName,
      'userName' : userName,
      'nickName' : nickName,
      'summary': summary,
      'bio' : bio,

      'createdAt': createdAt,
      'isVerified' : isVerified ?? false,
      'fcmToken' : fcmToken,
    };


  }

  UserModel copyWith({
  String email,
  String userId,
  String key,
    String nickName,
  String displayName,
  String userName,

    String bio,
    String summary,

    String createdAt,
  String fcmToken,

  bool isVerified,



  }) {
    return UserModel(
      email: email ?? this.email,

      displayName: displayName ?? this.displayName,
      userName: userName ?? this.userName,
      nickName: nickName ?? this.nickName,

      summary: summary ?? this.summary,
      bio: bio ?? this.bio,


      createdAt: createdAt ?? this.createdAt,


      isVerified: isVerified ?? this.isVerified,
      key: key ?? this.key,


      userId: userId ?? this.userId,
      fcmToken: fcmToken ?? this.fcmToken,


    );
  }





}