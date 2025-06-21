import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/community_model.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final communityModel = Provider.of<CommunityModel>(context);
    final posts = communityModel.posts;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Community'),
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreatePostDialog(context),
              ),
            ],
          ),
          if (posts.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No posts yet. Be the first to post!')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPostCard(posts[index]),
                childCount: posts.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      post.userAvatar != null
                          ? NetworkImage(post.userAvatar!)
                          : null,
                  child:
                      post.userAvatar == null ? Text(post.username[0]) : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMM d, y • h:mm a').format(post.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    // Handle like
                  },
                ),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                const Icon(Icons.comment),
                const SizedBox(width: 4),
                Text('${post.comments}'),
                const Spacer(),
                const Icon(Icons.share, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Post'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: 'Share your fitness journey...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                const Text('Add photo (optional)'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Icon(Icons.add_a_photo, size: 40)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (contentController.text.isEmpty) return;

                final newPost = CommunityPost(
                  username: 'You',
                  userAvatar: null,
                  content: contentController.text,
                  timestamp: DateTime.now(),
                  likes: 0,
                  comments: 0,
                  isLiked: false,
                );

                Provider.of<CommunityModel>(
                  context,
                  listen: false,
                ).addPost(newPost);

                Navigator.pop(context);
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }
}
