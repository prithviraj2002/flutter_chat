class Post{
  final String imgSrc;
  final String caption;
  final int likes;

  Post({
    required this.imgSrc,
    required this.caption,
    required this.likes
  });

  factory Post.fromMap(Map<String, dynamic> json){
    return Post(imgSrc: json['imgSrc'], caption: json['caption'], likes: json['likes']);
  }

  Map<String, dynamic> toMap(){
    return{
      'imgSrc': imgSrc,
      'caption': caption,
      'likes': likes,
    };
  }
}