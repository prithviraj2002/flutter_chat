class Message{
  final String msg;
  final String userId;
  final String recieverId;

  Message({
    required this.msg,
    required this.userId,
    required this.recieverId
  });

  factory Message.fromMap(Map<String, dynamic> json){
    return Message(
        msg: json['message'],
        userId: json['userId'],
        recieverId: json['recieverId']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'message': msg,
      'userId' : userId,
      'recieverId': recieverId
    };
  }
}