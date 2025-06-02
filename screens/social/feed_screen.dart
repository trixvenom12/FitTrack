import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';
import 'package:fittrack/model/post.dart';
import 'package:fittrack/widgets/comment_section.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Post> _posts = [
    // Mock data - in real app this would come from API
    Post(
      id: 1,
      userId: 1,
      username: "fitness_lover",
      userImage: "https://randomuser.me/api/portraits/women/44.jpg",
      content: "Just completed my 10k run! Feeling amazing! 🏃‍♀️",
      imageUrl: "https://images.unsplash.com/photo-1552674605-db6ffd4facb5",
      likes: 24,
      comments: 5,
      timeAgo: "2 hours ago",
      isLiked: false,
    ),
    Post(
      id: 2,
      userId: 2,
      username: "gym_enthusiast",
      userImage: "https://randomuser.me/api/portraits/men/32.jpg",
      content: "New personal record on bench press today! 225lbs! 💪",
      imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b",
      likes: 42,
      comments: 8,
      timeAgo: "5 hours ago",
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Feed')),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User header
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(post.userImage),
                  ),
                  title: Text(post.username),
                  subtitle: Text(post.timeAgo),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),

                // Post content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(post.content),
                ),

                // Post image
                if (post.imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                // Like and comment buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      LikeButton(
                        isLiked: post.isLiked,
                        likeCount: post.likes,
                        countBuilder: (count, isLiked, text) {
                          return Text(
                            text,
                            style: TextStyle(
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                          );
                        },
                        onTap: (isLiked) async {
                          // Send like to backend
                          return !isLiked;
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                CommentSection(postId: post.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to create post screen
        },
      ),
    );
  }
}
