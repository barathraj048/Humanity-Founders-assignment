// lib/init/services/cloudinary_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  // Replace these with your actual Cloudinary credentials
  static const String CLOUD_NAME = 'your_cloud_name_here';
  static const String UPLOAD_PRESET = 'faithconnect';

  static const String IMAGE_UPLOAD_URL =
      'https://api.cloudinary.com/v1_1/$CLOUD_NAME/image/upload';
  static const String VIDEO_UPLOAD_URL =
      'https://api.cloudinary.com/v1_1/$CLOUD_NAME/video/upload';

  // Upload image to Cloudinary
  static Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(IMAGE_UPLOAD_URL));

      request.fields['upload_preset'] = UPLOAD_PRESET;
      request.fields['folder'] = 'faithconnect/images';

      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = json.decode(responseString);

        print('✅ Image uploaded successfully: ${jsonMap['secure_url']}');
        return jsonMap['secure_url'];
      } else {
        print('❌ Image upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Image upload error: $e');
      return null;
    }
  }

  // Upload video to Cloudinary
  static Future<String?> uploadVideo(File videoFile,
      {Function(double)? onProgress}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(VIDEO_UPLOAD_URL));

      request.fields['upload_preset'] = UPLOAD_PRESET;
      request.fields['folder'] = 'faithconnect/videos';
      request.fields['resource_type'] = 'video';

      // Get file size for progress tracking
      final fileSize = await videoFile.length();

      request.files
          .add(await http.MultipartFile.fromPath('file', videoFile.path));

      // Send request with progress tracking
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final responseData = await streamedResponse.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = json.decode(responseString);

        print('✅ Video uploaded successfully: ${jsonMap['secure_url']}');
        return jsonMap['secure_url'];
      } else {
        print('❌ Video upload failed: ${streamedResponse.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Video upload error: $e');
      return null;
    }
  }

  // Delete media from Cloudinary (optional - requires API key and secret)
  static Future<bool> deleteMedia(String publicId) async {
    // This requires authentication with API key and secret
    // For now, we'll leave deletion to Cloudinary's auto-cleanup policies
    print('⚠️ Delete operation requires API key - implement if needed');
    return false;
  }

  // Get optimized image URL with transformations
  static String getOptimizedImageUrl(
    String originalUrl, {
    int? width,
    int? height,
    String quality = 'auto',
  }) {
    if (!originalUrl.contains('cloudinary.com')) return originalUrl;

    final parts = originalUrl.split('/upload/');
    if (parts.length != 2) return originalUrl;

    String transformation = 'q_$quality';
    if (width != null) transformation += ',w_$width';
    if (height != null) transformation += ',h_$height';

    return '${parts[0]}/upload/$transformation/${parts[1]}';
  }

  // Get video thumbnail URL
  static String getVideoThumbnail(String videoUrl) {
    if (!videoUrl.contains('cloudinary.com')) return videoUrl;

    final parts = videoUrl.split('/upload/');
    if (parts.length != 2) return videoUrl;

    // Get thumbnail from first frame
    return '${parts[0]}/upload/so_0,f_jpg/${parts[1]}';
  }
}
