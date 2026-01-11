class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String authorPhotoURL;
  final String content;
  final String? imageUrl;
  final List<String> likes;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoURL,
    required this.content,
    this.imageUrl,
    this.likes = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['_id'] ?? map['id'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      authorPhotoURL: map['authorPhotoURL'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      likes: List<String>.from(map['likes'] ?? []),
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(
              map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoURL': authorPhotoURL,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
