class Message{
  final String message;
  final String userId;
  final String receiverId;
  final String time;
  final String id;

  Message({
    required this.message,
    required this.userId,
    required this.receiverId,
    required this.time,
    required this.id
  });

  factory Message.fromMap(Map<String, dynamic> json){
    return Message(
        message: json['message'],
        userId: json['userId'],
        receiverId: json['receiverId'],
      time: json['time'],
      id: json['id']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'message': message,
      'userId' : userId,
      'receiverId': receiverId,
      'time': time,
      'id': id
    };
  }
}