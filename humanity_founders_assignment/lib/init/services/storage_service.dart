// lib/init/services/storage_service.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImage(File image, String path) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('$path/$fileName.jpg');

      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error uploading image: $e');
      }
      return null;
    }
  }

  // Upload profile picture
  Future<String?> uploadProfilePicture(File image, String userId) async {
    return await uploadImage(image, 'profiles/$userId');
  }

  // Upload post image
  Future<String?> uploadPostImage(File image, String postId) async {
    return await uploadImage(image, 'posts/$postId');
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error deleting image: $e');
      }
    }
  }
}

// Global instance
final StorageService storageService = StorageService();
