class Post {
  final int id;
  final int userId;
  final String username;
  final String userImage;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final String timeAgo;
  bool isLiked;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    this.isLiked = false,
  });
}
