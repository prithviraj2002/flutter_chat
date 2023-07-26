class ConnectProfile{
  final String userName;
  final String bio;
  final String userId;

  ConnectProfile({
    required this.userName,
    required this.bio,
    required this.userId,
  });

  factory ConnectProfile.fromMap(Map<String, dynamic> json){
    return ConnectProfile(
        userName: json['userName'],
        bio: json['bio'],
        userId: json['userId'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'userName': userName,
      'bio': bio,
      'userId': userId
    };
  }
}