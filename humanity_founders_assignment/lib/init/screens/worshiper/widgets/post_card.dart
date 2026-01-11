import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int likeCount = 128;
  int commentCount = 34;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=33",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rabbi Abraham Cohen",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "2h ago",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey.shade400),
              ],
            ),
          ),

          // Post text content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Faith is not about everything turning out okay. Faith is about being okay no matter how things turn out. 🙏",
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Post image
          Image.network(
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800",
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
          ),

          // Action buttons row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                      likeCount += isLiked ? 1 : -1;
                    });
                  },
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.send_outlined, color: Colors.white, size: 24),
                const Spacer(),
                const Icon(
                  Icons.bookmark_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),

          // Like count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$likeCount likes",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // View comments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              "View all $commentCount comments",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
