import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// FCM Notification Service
/// Handles:
/// - FCM token management
/// - Push notification reception
/// - Local notification display
/// - Background/foreground notification handling
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Set this to true to receive notifications even for your own actions (useful for testing)
  static const bool enableTestMode = true;

  /// Initialize FCM and local notifications
  Future<void> initialize() async {
    // Request notification permissions
    await _requestPermissions();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Get and save FCM token
    await _getFCMToken();

    // Listen for token refresh
    _fcm.onTokenRefresh.listen(_onTokenRefresh);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps (app in background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle initial notification (app opened from terminated state)
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('✅ User granted provisional notification permission');
    } else {
      print('❌ User declined notification permission');
    }
  }

  /// Initialize local notifications (for foreground display)
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'campuswhisper_channel', // id
        'CampusWhisper Notifications', // name
        description: 'Notifications for comments and replies',
        importance: Importance.high,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Get FCM token and save to Firestore
  Future<void> _getFCMToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        _fcmToken = token;
        await _saveTokenToFirestore(token);
        print('✅ FCM Token: $token');
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  }

  /// Save FCM token to user document in Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print('✅ FCM token saved to Firestore');
      } catch (e) {
        print('❌ Error saving FCM token: $e');
      }
    }
  }

  /// Handle FCM token refresh
  Future<void> _onTokenRefresh(String token) async {
    _fcmToken = token;
    await _saveTokenToFirestore(token);
    print('✅ FCM token refreshed: $token');
  }

  /// Handle foreground messages (show local notification)
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Foreground message received: ${message.messageId}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Display notification using local notifications
    if (notification != null && android != null) {
      await _showLocalNotification(
        title: notification.title ?? 'New notification',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'campuswhisper_channel',
      'CampusWhisper Notifications',
      channelDescription: 'Notifications for comments and replies',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  /// Handle notification tap (app in background)
  void _handleNotificationTap(RemoteMessage message) {
    print('📱 Notification tapped: ${message.data}');

    // Navigate based on notification data
    final data = message.data;
    if (data.containsKey('type')) {
      final type = data['type'];
      if (type == 'comment' || type == 'reply') {
        // TODO: Navigate to thread detail page
        final postId = data['postId'];
        print('Navigate to post: $postId');
        // You can use a navigation service or global navigator key here
      }
    }
  }

  /// Handle local notification tap
  void _onLocalNotificationTap(NotificationResponse response) {
    print('📱 Local notification tapped: ${response.payload}');
    // Handle navigation here
  }

  /// Send notification when someone comments on a post
  Future<void> sendCommentNotification({
    required String postId,
    required String postOwnerId,
    required String commenterName,
    required String commentText,
  }) async {
    // Don't send notification to yourself (unless in test mode)
    final currentUser = FirebaseAuth.instance.currentUser;
    if (!enableTestMode && currentUser?.uid == postOwnerId) return;

    try {
      // Get post owner's FCM token
      final ownerDoc = await _firestore.collection('users').doc(postOwnerId).get();
      final fcmToken = ownerDoc.data()?['fcmToken'] as String?;

      if (fcmToken != null) {
        // Store notification in Firestore (to be sent by Cloud Function)
        await _firestore.collection('notifications').add({
          'token': fcmToken,
          'notification': {
            'title': 'New Comment',
            'body': '$commenterName commented: $commentText',
          },
          'data': {
            'type': 'comment',
            'postId': postId,
            'commenterId': currentUser?.uid,
            'commenterName': commenterName,
          },
          'createdAt': FieldValue.serverTimestamp(),
          'sent': false,
        });
        print('✅ Comment notification queued');
      }
    } catch (e) {
      print('❌ Error sending comment notification: $e');
    }
  }

  /// Send notification when someone replies to a comment
  Future<void> sendReplyNotification({
    required String postId,
    required String postOwnerId,
    required String commentOwnerId,
    required String replierName,
    required String replyText,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      // Send to comment owner (if not replying to yourself, or if in test mode)
      if (enableTestMode || currentUser?.uid != commentOwnerId) {
        final commentOwnerDoc =
            await _firestore.collection('users').doc(commentOwnerId).get();
        final fcmToken = commentOwnerDoc.data()?['fcmToken'] as String?;

        if (fcmToken != null) {
          await _firestore.collection('notifications').add({
            'token': fcmToken,
            'notification': {
              'title': 'New Reply',
              'body': '$replierName replied: $replyText',
            },
            'data': {
              'type': 'reply',
              'postId': postId,
              'replierId': currentUser?.uid,
              'replierName': replierName,
            },
            'createdAt': FieldValue.serverTimestamp(),
            'sent': false,
          });
        }
      }

      // Also send to post owner (if different from comment owner and not yourself, or if in test mode)
      if (postOwnerId != commentOwnerId && (enableTestMode || currentUser?.uid != postOwnerId)) {
        final postOwnerDoc =
            await _firestore.collection('users').doc(postOwnerId).get();
        final fcmToken = postOwnerDoc.data()?['fcmToken'] as String?;

        if (fcmToken != null) {
          await _firestore.collection('notifications').add({
            'token': fcmToken,
            'notification': {
              'title': 'New Reply on Your Post',
              'body': '$replierName replied to a comment: $replyText',
            },
            'data': {
              'type': 'reply',
              'postId': postId,
              'replierId': currentUser?.uid,
              'replierName': replierName,
            },
            'createdAt': FieldValue.serverTimestamp(),
            'sent': false,
          });
        }
      }

      print('✅ Reply notification(s) queued');
    } catch (e) {
      print('❌ Error sending reply notification: $e');
    }
  }

  /// Delete FCM token on logout
  Future<void> deleteToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': FieldValue.delete(),
        });
        await _fcm.deleteToken();
        _fcmToken = null;
        print('✅ FCM token deleted');
      } catch (e) {
        print('❌ Error deleting FCM token: $e');
      }
    }
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📨 Background message received: ${message.messageId}');
  // Handle background messages here if needed
}
