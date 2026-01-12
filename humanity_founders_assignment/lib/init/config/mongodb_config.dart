// lib/init/config/mongodb_config.dart

class MongoDBConfig {
  // MongoDB Connection String
  // IMPORTANT: Special characters in password must be URL-encoded
  // @ = %40, # = %23, $ = %24, etc.
  // For security, use environment variables in production
  static const String CONNECTION_STRING =
      'mongodb+srv://Barath:Barath%40123@cluster0.qhk5rnr.mongodb.net/faithconnect?retryWrites=true&w=majority&appName=Cluster0';

  // Database Name
  static const String DATABASE_NAME = 'faithconnect';

  // Collection Names
  static const String USERS_COLLECTION = 'users';
  static const String POSTS_COLLECTION = 'posts';
  static const String COMMENTS_COLLECTION = 'comments';
  static const String REELS_COLLECTION = 'reels';
  static const String MESSAGES_COLLECTION = 'messages';
  static const String NOTIFICATIONS_COLLECTION = 'notifications';
  static const String EVENTS_COLLECTION = 'events';
  static const String PRAYERS_COLLECTION = 'prayers';
  static const String FOLLOWS_COLLECTION = 'follows';
  static const String STORIES_COLLECTION = 'stories';

  // Settings
  static const int DEFAULT_PAGE_SIZE = 20;
  static const int MAX_MESSAGES_PER_CONVERSATION = 50;
  static const int CONNECTION_TIMEOUT = 10000; // 10 seconds

  // Validation
  static bool isValidConnectionString() {
    return CONNECTION_STRING.isNotEmpty &&
        CONNECTION_STRING.startsWith('mongodb');
  }

  // Prevent instantiation
  MongoDBConfig._();
}
