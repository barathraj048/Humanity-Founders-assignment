// lib/init/screens/create_reel_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import '../services/mongodb_service.dart';
import '../services/cloudinary_service.dart';

class CreateReelScreen extends StatefulWidget {
  const CreateReelScreen({Key? key}) : super(key: key);

  @override
  State<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends State<CreateReelScreen> {
  final _captionController = TextEditingController();
  final _mongoDBService = MongoDBService();
  final _imagePicker = ImagePicker();

  File? _selectedVideo;
  VideoPlayerController? _videoController;
  bool _isLoading = false;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _captionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 1),
      );

      if (video != null) {
        final file = File(video.path);

        // Initialize video player for preview
        final controller = VideoPlayerController.file(file);
        await controller.initialize();

        setState(() {
          _selectedVideo = file;
          _videoController = controller;
        });

        // Auto-play preview
        controller.play();
        controller.setLooping(true);
      }
    } catch (e) {
      _showError('Failed to pick video: $e');
    }
  }

  Future<void> _createReel() async {
    if (_selectedVideo == null) {
      _showError('Please select a video');
      return;
    }

    final caption = _captionController.text.trim();

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user data from MongoDB
      final userData = await _mongoDBService.getUser(user.uid);

      // Upload video to Cloudinary
      final videoUrl = await CloudinaryService.uploadVideo(
        _selectedVideo!,
        onProgress: (progress) {
          if (mounted) {
            setState(() => _uploadProgress = progress);
          }
        },
      );

      if (videoUrl == null) throw Exception('Video upload failed');

      // Create reel data
      final reelData = {
        '_id': const Uuid().v4(),
        'authorId': user.uid,
        'authorName':
            userData?['displayName'] ?? user.displayName ?? 'Anonymous',
        'authorPhoto': userData?['photoURL'] ?? user.photoURL,
        'videoUrl': videoUrl,
        'thumbnailUrl': CloudinaryService.getVideoThumbnail(videoUrl),
        'caption': caption,
        'likes': [],
        'likeCount': 0,
        'views': 0,
        'comments': [],
        'commentCount': 0,
        'createdAt': DateTime.now(),
      };

      // Save reel to MongoDB
      await _mongoDBService.createReel(reelData);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reel created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to create reel: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Reel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _selectedVideo != null ? _createReel : null,
              child: Text(
                'Post',
                style: TextStyle(
                  color: _selectedVideo != null ? Colors.blue : Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Video preview
            if (_selectedVideo != null && _videoController != null) ...[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_videoController!),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                          ),
                          onPressed: () {
                            _videoController?.dispose();
                            setState(() {
                              _selectedVideo = null;
                              _videoController = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Caption input
            TextField(
              controller: _captionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Add a caption...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Upload progress
            if (_isLoading && _uploadProgress > 0) ...[
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: const Color(0xFF1A1A1A),
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                'Uploading: ${(_uploadProgress * 100).toInt()}%',
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 20),
            ],

            // Select video button
            if (_selectedVideo == null)
              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.video_library,
                          color: Colors.purple,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Select Video',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
