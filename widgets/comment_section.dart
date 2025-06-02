import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  final int postId;

  const CommentSection({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    // Replace with real comment logic later
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Comments", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text("Showing comments for Post ID: $postId"),
          const SizedBox(height: 10),
          const TextField(
            decoration: InputDecoration(
              hintText: "Write a comment...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Post comment logic
              Navigator.pop(context);
            },
            child: const Text("Post Comment"),
          ),
        ],
      ),
    );
  }
}
