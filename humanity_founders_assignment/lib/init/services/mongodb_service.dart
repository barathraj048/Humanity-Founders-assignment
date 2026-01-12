// lib/init/services/mongodb_service.dart

import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/foundation.dart';
import '../config/mongodb_config.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  factory MongoDBService() => _instance;
  MongoDBService._internal();

  Db? _db;
  bool _isConnected = false;

  bool get isConnected => _isConnected;
  Db? get database => _db;

  // Connect to MongoDB
  Future<void> connect() async {
    if (_isConnected && _db != null) return;

    try {
      _db = await Db.create(MongoDBConfig.CONNECTION_STRING);
      await _db!.open();
      _isConnected = true;
      if (kDebugMode) {
        debugPrint('✅ MongoDB connected successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ MongoDB connection failed: $e');
      }
      rethrow;
    }
  }

  // Ensure connection before operations
  Future<void> _ensureConnected() async {
    if (!_isConnected || _db == null) {
      await connect();
    }
  }

  // Get collection
  DbCollection _getCollection(String collectionName) {
    return _db!.collection(collectionName);
  }

  // ==================== USER OPERATIONS ====================

  Future<void> createUser(Map<String, dynamic> userData) async {
    await _ensureConnected();
    final users = _getCollection(MongoDBConfig.USERS_COLLECTION);
    await users.insertOne(userData);
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    await _ensureConnected();
    final users = _getCollection(MongoDBConfig.USERS_COLLECTION);
    // Try finding by _id first (for MongoDB ObjectId)
    var user = await users.findOne(where.eq('_id', userId));
    // If not found, try finding by firebaseUid using null-aware operator
    user ??= await users.findOne(where.eq('firebaseUid', userId));
    return user;
  }

  Future<Map<String, dynamic>?> getUserByFirebaseUid(String firebaseUid) async {
    await _ensureConnected();
    final users = _getCollection(MongoDBConfig.USERS_COLLECTION);
    return await users.findOne(where.eq('firebaseUid', firebaseUid));
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _ensureConnected();
    final users = _getCollection(MongoDBConfig.USERS_COLLECTION);
    await users.updateOne(
      where.eq('_id', userId),
      modify
          .set('displayName', updates['displayName'])
          .set('photoURL', updates['photoURL'])
          .set('bio', updates['bio']),
    );
  }

  // ==================== POST OPERATIONS ====================

  Future<void> createPost(Map<String, dynamic> postData) async {
    await _ensureConnected();
    final posts = _getCollection(MongoDBConfig.POSTS_COLLECTION);
    await posts.insertOne(postData);
  }

  Future<List<Map<String, dynamic>>> getPosts({int limit = 20}) async {
    await _ensureConnected();
    final posts = _getCollection(MongoDBConfig.POSTS_COLLECTION);
    return await posts
        .find(where.sortBy('createdAt', descending: true).limit(limit))
        .toList();
  }

  Future<void> likePost(String postId, String userId) async {
    await _ensureConnected();
    final posts = _getCollection(MongoDBConfig.POSTS_COLLECTION);

    final post = await posts.findOne(where.eq('_id', postId));
    if (post == null) return;

    List<String> likes = List<String>.from(post['likes'] ?? []);

    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    await posts.updateOne(
      where.eq('_id', postId),
      modify.set('likes', likes).set('likeCount', likes.length),
    );
  }

  Future<void> addComment(String postId, Map<String, dynamic> comment) async {
    await _ensureConnected();
    final posts = _getCollection(MongoDBConfig.POSTS_COLLECTION);

    await posts.updateOne(
      where.eq('_id', postId),
      modify.push('comments', comment).inc('commentCount', 1),
    );
  }

  // ==================== REEL OPERATIONS ====================

  Future<void> createReel(Map<String, dynamic> reelData) async {
    await _ensureConnected();
    final reels = _getCollection(MongoDBConfig.REELS_COLLECTION);
    await reels.insertOne(reelData);
  }

  Future<List<Map<String, dynamic>>> getReels({int limit = 20}) async {
    await _ensureConnected();
    final reels = _getCollection(MongoDBConfig.REELS_COLLECTION);
    return await reels
        .find(where.sortBy('createdAt', descending: true).limit(limit))
        .toList();
  }

  Future<void> likeReel(String reelId, String userId) async {
    await _ensureConnected();
    final reels = _getCollection(MongoDBConfig.REELS_COLLECTION);

    final reel = await reels.findOne(where.eq('_id', reelId));
    if (reel == null) return;

    List<String> likes = List<String>.from(reel['likes'] ?? []);

    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    await reels.updateOne(
      where.eq('_id', reelId),
      modify.set('likes', likes).set('likeCount', likes.length),
    );
  }

  // ==================== MESSAGE OPERATIONS ====================

  Future<void> sendMessage(Map<String, dynamic> messageData) async {
    await _ensureConnected();
    final messages = _getCollection(MongoDBConfig.MESSAGES_COLLECTION);
    await messages.insertOne(messageData);
  }

  Future<List<Map<String, dynamic>>> getConversation(
    String userId1,
    String userId2, {
    int limit = 50,
  }) async {
    await _ensureConnected();
    final messages = _getCollection(MongoDBConfig.MESSAGES_COLLECTION);

    final conversationId1 = '${userId1}_$userId2';
    final conversationId2 = '${userId2}_$userId1';

    // Fixed: Use $or operator with raw MongoDB query
    final result = await messages
        .find(
          where
              .raw({
                '\$or': [
                  {'conversationId': conversationId1},
                  {'conversationId': conversationId2},
                ],
              })
              .sortBy('createdAt')
              .limit(limit),
        )
        .toList();

    // Convert ObjectId to String and parse dates
    return result.map((msg) {
      if (msg['_id'] is ObjectId) {
        msg['_id'] = (msg['_id'] as ObjectId).oid;
      }
      if (msg['createdAt'] is String) {
        msg['createdAt'] = DateTime.parse(msg['createdAt']);
      }
      return msg;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getRecentConversations(
    String userId,
  ) async {
    await _ensureConnected();
    final messages = _getCollection(MongoDBConfig.MESSAGES_COLLECTION);

    // Fixed: Use $or operator with raw MongoDB query
    final allMessages = await messages
        .find(
          where.raw({
            '\$or': [
              {'senderId': userId},
              {'receiverId': userId},
            ],
          }),
        )
        .toList();

    // Group by conversation and get latest message
    Map<String, Map<String, dynamic>> conversations = {};

    for (var msg in allMessages) {
      final conversationId = msg['conversationId'] as String;

      // Convert createdAt to DateTime if it's a string
      DateTime msgTime;
      if (msg['createdAt'] is String) {
        msgTime = DateTime.parse(msg['createdAt']);
        msg['createdAt'] = msgTime;
      } else {
        msgTime = msg['createdAt'] as DateTime;
      }

      if (!conversations.containsKey(conversationId) ||
          msgTime.isAfter(
              conversations[conversationId]!['createdAt'] as DateTime)) {
        conversations[conversationId] = msg;
      }
    }

    // Convert to list and sort by createdAt
    final result = conversations.values.toList();
    result.sort((a, b) =>
        (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));

    return result;
  }

  Future<void> markMessageAsRead(String messageId) async {
    await _ensureConnected();
    final messages = _getCollection(MongoDBConfig.MESSAGES_COLLECTION);

    try {
      await messages.updateOne(
        where.eq('_id', messageId),
        modify.set('isRead', true),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error marking message as read: $e');
      }
    }
  }

  // ==================== CONNECTION MANAGEMENT ====================

  Future<void> close() async {
    if (_isConnected && _db != null) {
      await _db!.close();
      _isConnected = false;
      if (kDebugMode) {
        debugPrint('MongoDB connection closed');
      }
    }
  }
}
