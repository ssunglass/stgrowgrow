class UserModel{
  String key;
  String email;
  String userId;
  String displayName;
  String userName;
  String nickName;
  String university;

  String profilePic;

  String summary;
  String bio;


  bool isVerified;


  String createdAt;
  String fcmToken;

  int followers;
  int following;
  List<String> followerList;
  List<String> followingList;

  String major;
  List<String> interestList;






  UserModel({
  this.email,
  this.userId,
  this.key,
  this.displayName,
  this.userName,
    this.nickName,
    this.summary,
    this.bio,
    this.university,

    this.followers,
    this.following,

    this.profilePic,

    this.createdAt,
  this.isVerified,
  this.fcmToken,

    this.followerList,

    this.major,
    this.interestList,




});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if(map == null) {
      return;
    }
    if(followerList == null) {
      followerList=[];
    }
    email = map['email'];
    userId = map ['userId'];
    key = map['key'];
    displayName = map['displayName'];
    userName = map['userName'];
    nickName = map['nickName'];
    summary = map['summary'];
    bio = map['bio'];
    university = map['university'];

    profilePic = map['profilePic'];

    followers = map['followers'];
    following = map['following'];



    createdAt = map['createdAt'];
    fcmToken = map['fcmToken'];
    isVerified = map['isVerified'] ?? false;

    major = map['major'];

    if(map['interestList'] != null) {
      interestList = [];
      map['interestList'].forEach((value) {
        interestList.add(value);
      });
    }

    if(map['followerList'] != null) {
      followerList = [];
      map['followerList'].forEach((value) {
        followerList.add(value);
      });
    }
    if(map['followingList'] != null) {
      followingList = [];
      map['followingList'].forEach((value) {
        followingList.add(value);
      });
    }
    following = followingList != null ? followingList.length : null;







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
      'university' : university,

      'profilePic' : profilePic,

      'createdAt': createdAt,
      'isVerified' : isVerified ?? false,
      'fcmToken' : fcmToken,

      'major' : major,
      'interestList' : interestList,

      'followers' : followerList != null ? followerList.length : null,
      'following' : followingList != null ? followingList.length : null,

      'followerList' : followerList,
      'followingList' : followingList,



    };


  }

  UserModel copyWith({
  String email,
  String userId,
  String key,
    String nickName,
  String displayName,
  String userName,

    String profilePic,
    String university,

    String bio,
    String summary,

    String createdAt,
  String fcmToken,

  bool isVerified,

    int followers,
    int following,

    String major,

    List<String> followingList,
    List<String> interestList,






  }) {
    return UserModel(
      email: email ?? this.email,

      displayName: displayName ?? this.displayName,
      userName: userName ?? this.userName,
      nickName: nickName ?? this.nickName,

      summary: summary ?? this.summary,
      bio: bio ?? this.bio,

      profilePic: profilePic ?? this.profilePic,
      university: university ?? this.university,


      createdAt: createdAt ?? this.createdAt,


      isVerified: isVerified ?? this.isVerified,
      key: key ?? this.key,

      followers: followerList != null ? followerList.length : null,
      following: following ?? this.following,

      userId: userId ?? this.userId,
      fcmToken: fcmToken ?? this.fcmToken,

      major: major ?? this.major,
      interestList: interestList ?? this.interestList,
      followerList: followerList ?? this.followerList,





    );
  }

  String getFollower() {
    return '${this.followers ?? 0}';
  }

  String getFollowing() {
    return '${this.following ?? 0}';
  }





}