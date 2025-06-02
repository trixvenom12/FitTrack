import 'package:flutter/material.dart';

class CommunityPost {
  final String username;
  final String? userAvatar;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final bool isLiked;

  CommunityPost({
    required this.username,
    this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });
}

class CommunityModel with ChangeNotifier {
  final List<CommunityPost> _posts = [];

  List<CommunityPost> get posts => _posts;

  void addPost(CommunityPost post) {
    _posts.insert(0, post);
    notifyListeners();
  }
}
