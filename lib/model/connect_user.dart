class ConnectUser{
  final String email;
  final String password;
  final String userId;

  ConnectUser({
    required this.email,
    required this.password,
    required this.userId
  });

  factory ConnectUser.fromMap(Map<String, dynamic> json){
    return ConnectUser(email: json['email'], password: json['password'], userId: json['userId']);
  }

  Map<String, dynamic> toMap(){
    return {
      'email': email,
      'password': password,
      'userId': userId
    };
  }
}