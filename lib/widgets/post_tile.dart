import 'package:assignment_app/models/post_models.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final PostModel post;

  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 10),
                Text(
                  'User ID: ${post.userId}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
