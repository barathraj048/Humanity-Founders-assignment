import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/event_model.dart';
import '../models/prayer_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============ POSTS ============

  // Create post
  Future<void> createPost(PostModel post) async {
    await _db.collection('posts').doc(post.id).set(post.toMap());
  }

  // Get posts stream (for feed)
  Stream<List<PostModel>> getPostsStream() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Like/Unlike post
  Future<void> toggleLikePost(String postId, String userId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);

      if (!snapshot.exists) return;

      List<dynamic> likes = snapshot.get('likes') ?? [];

      if (likes.contains(userId)) {
        transaction.update(postRef, {
          'likes': FieldValue.arrayRemove([userId]),
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        transaction.update(postRef, {
          'likes': FieldValue.arrayUnion([userId]),
          'likeCount': FieldValue.increment(1),
        });
      }
    });
  }

  // Add comment
  Future<void> addComment(String postId, Map<String, dynamic> comment) async {
    await _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(comment);

    // Increment comment count
    await _db.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  // ============ EVENTS ============

  // Create event
  Future<void> createEvent(EventModel event) async {
    await _db.collection('events').doc(event.id).set(event.toMap());
  }

  // Get events stream
  Stream<List<EventModel>> getEventsStream() {
    return _db
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Register for event
  Future<void> registerForEvent(String eventId, String userId) async {
    await _db.collection('events').doc(eventId).update({
      'attendees': FieldValue.arrayUnion([userId]),
      'attendeeCount': FieldValue.increment(1),
    });
  }

  // ============ PRAYERS ============

  // Create prayer request
  Future<void> createPrayer(PrayerModel prayer) async {
    await _db.collection('prayers').doc(prayer.id).set(prayer.toMap());
  }

  // Get prayers stream
  Stream<List<PrayerModel>> getPrayersStream() {
    return _db
        .collection('prayers')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PrayerModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Pray for someone
  Future<void> prayFor(String prayerId, String userId) async {
    await _db.collection('prayers').doc(prayerId).update({
      'prayedBy': FieldValue.arrayUnion([userId]),
      'prayerCount': FieldValue.increment(1),
    });
  }

  // ============ USERS ============

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // Get leader stats
  Future<Map<String, dynamic>?> getLeaderStats(String uid) async {
    DocumentSnapshot doc = await _db.collection('leaders').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Get community members (for leaders)
  Stream<List<Map<String, dynamic>>> getCommunityMembersStream() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'worshiper')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

final FirestoreService firestoreService = FirestoreService();
