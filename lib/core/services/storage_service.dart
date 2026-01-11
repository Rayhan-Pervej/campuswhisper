import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

/// Firebase Storage Service
///
/// Handles all file upload/download operations to Firebase Storage
/// Supports images, documents, and other file types
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ═══════════════════════════════════════════════════════════════
  // IMAGE UPLOADS
  // ═══════════════════════════════════════════════════════════════

  /// Upload image to Firebase Storage
  /// Returns the download URL
  Future<String> uploadImage({
    required File file,
    required String folder,
    String? fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final String fileExtension = path.extension(file.path);
      final String uploadFileName = fileName ?? '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final String filePath = '$folder/$uploadFileName';

      final Reference ref = _storage.ref().child(filePath);
      final UploadTask uploadTask = ref.putFile(file);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      await uploadTask;
      final String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw StorageException(
        message: 'Failed to upload image',
        code: 'UPLOAD_FAILED',
        originalError: e,
      );
    }
  }

  /// Upload multiple images
  /// Returns list of download URLs
  Future<List<String>> uploadImages({
    required List<File> files,
    required String folder,
    Function(int, int)? onProgress, // (current, total)
  }) async {
    try {
      final List<String> urls = [];

      for (int i = 0; i < files.length; i++) {
        final url = await uploadImage(
          file: files[i],
          folder: folder,
        );
        urls.add(url);

        if (onProgress != null) {
          onProgress(i + 1, files.length);
        }
      }

      return urls;
    } catch (e) {
      throw StorageException(
        message: 'Failed to upload images',
        code: 'BATCH_UPLOAD_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PROFILE IMAGES
  // ═══════════════════════════════════════════════════════════════

  /// Upload user profile image
  Future<String> uploadProfileImage({
    required File file,
    required String userId,
    Function(double)? onProgress,
  }) async {
    return uploadImage(
      file: file,
      folder: 'profiles/$userId',
      fileName: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      onProgress: onProgress,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // POST IMAGES
  // ═══════════════════════════════════════════════════════════════

  /// Upload post images
  Future<List<String>> uploadPostImages({
    required List<File> files,
    required String postId,
    Function(int, int)? onProgress,
  }) async {
    return uploadImages(
      files: files,
      folder: 'posts/$postId',
      onProgress: onProgress,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // EVENT IMAGES
  // ═══════════════════════════════════════════════════════════════

  /// Upload event images
  Future<List<String>> uploadEventImages({
    required List<File> files,
    required String eventId,
    Function(int, int)? onProgress,
  }) async {
    return uploadImages(
      files: files,
      folder: 'events/$eventId',
      onProgress: onProgress,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CLUB IMAGES
  // ═══════════════════════════════════════════════════════════════

  /// Upload club logo
  Future<String> uploadClubLogo({
    required File file,
    required String clubId,
    Function(double)? onProgress,
  }) async {
    return uploadImage(
      file: file,
      folder: 'clubs/$clubId',
      fileName: 'logo.jpg',
      onProgress: onProgress,
    );
  }

  /// Upload club cover image
  Future<String> uploadClubCover({
    required File file,
    required String clubId,
    Function(double)? onProgress,
  }) async {
    return uploadImage(
      file: file,
      folder: 'clubs/$clubId',
      fileName: 'cover.jpg',
      onProgress: onProgress,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LOST & FOUND IMAGES
  // ═══════════════════════════════════════════════════════════════

  /// Upload lost/found item images
  Future<List<String>> uploadLostFoundImages({
    required List<File> files,
    required String itemId,
    Function(int, int)? onProgress,
  }) async {
    return uploadImages(
      files: files,
      folder: 'lost_found/$itemId',
      onProgress: onProgress,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FILE DELETION
  // ═══════════════════════════════════════════════════════════════

  /// Delete file by URL
  Future<void> deleteFile(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw StorageException(
        message: 'Failed to delete file',
        code: 'DELETE_FAILED',
        originalError: e,
      );
    }
  }

  /// Delete multiple files by URLs
  Future<void> deleteFiles(List<String> urls) async {
    try {
      for (final url in urls) {
        await deleteFile(url);
      }
    } catch (e) {
      throw StorageException(
        message: 'Failed to delete files',
        code: 'BATCH_DELETE_FAILED',
        originalError: e,
      );
    }
  }

  /// Delete entire folder
  Future<void> deleteFolder(String folderPath) async {
    try {
      final Reference ref = _storage.ref().child(folderPath);
      final ListResult result = await ref.listAll();

      // Delete all files in folder
      for (final Reference fileRef in result.items) {
        await fileRef.delete();
      }

      // Recursively delete subfolders
      for (final Reference folderRef in result.prefixes) {
        await deleteFolder(folderRef.fullPath);
      }
    } catch (e) {
      throw StorageException(
        message: 'Failed to delete folder',
        code: 'FOLDER_DELETE_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // FILE METADATA
  // ═══════════════════════════════════════════════════════════════

  /// Get file metadata
  Future<FullMetadata> getMetadata(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      return await ref.getMetadata();
    } catch (e) {
      throw StorageException(
        message: 'Failed to get file metadata',
        code: 'METADATA_FAILED',
        originalError: e,
      );
    }
  }

  /// Update file metadata
  Future<void> updateMetadata(String url, SettableMetadata metadata) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.updateMetadata(metadata);
    } catch (e) {
      throw StorageException(
        message: 'Failed to update file metadata',
        code: 'METADATA_UPDATE_FAILED',
        originalError: e,
      );
    }
  }
}

/// Storage exception
class StorageException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;

  StorageException({
    required this.message,
    required this.code,
    this.originalError,
  });

  @override
  String toString() => 'StorageException: $message (Code: $code)';
}
