# FCM Notification Setup Guide for CampusWhisper

This guide explains how to set up Firebase Cloud Messaging (FCM) notifications for the comment system.

## 📋 Overview

The notification system sends push notifications when:
- **Someone comments on your post** → Post owner receives notification
- **Someone replies to your comment** → Comment owner receives notification
- **Someone replies to a comment on your post** → Post owner receives notification

## 🏗️ Architecture

```
┌─────────────────┐
│   User A posts  │
│   a comment     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ CommentProvider │
│ creates comment │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Notification    │
│ Service queues  │
│ notification    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Firestore       │
│ 'notifications' │
│ collection      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Cloud Function  │
│ sends FCM msg   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ User B receives │
│ notification    │
└─────────────────┘
```

## 📱 Android Setup

### 1. Add google-services.json

Download from Firebase Console and place in `android/app/google-services.json`

### 2. Update android/build.gradle

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### 3. Update android/app/build.gradle

```gradle
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 21  // FCM requires min API 21
    }
}
```

### 4. Update AndroidManifest.xml

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <!-- FCM default notification icon -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@mipmap/ic_launcher" />

        <!-- FCM default notification color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />

        <!-- FCM notification channel -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="campuswhisper_channel" />
    </application>

    <!-- FCM permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
</manifest>
```

## 🍎 iOS Setup

### 1. Add GoogleService-Info.plist

Download from Firebase Console and place in `ios/Runner/GoogleService-Info.plist`

### 2. Enable Push Notifications

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Go to "Signing & Capabilities"
4. Click "+ Capability"
5. Add "Push Notifications"
6. Add "Background Modes"
7. Check "Remote notifications"

### 3. Update AppDelegate.swift

```swift
import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 4. Upload APNs Certificate

1. Go to Firebase Console → Project Settings → Cloud Messaging
2. Upload your APNs authentication key or certificate

## ☁️ Cloud Functions Setup

### 1. Install Firebase CLI

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Initialize Functions (if not done)

```bash
cd "d:\CodeFode\Flutter Project\campuswhisper"
firebase init functions
```

Select:
- Use existing project
- Select your Firebase project
- JavaScript
- Yes to ESLint
- Yes to install dependencies

### 4. Deploy Functions

```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

## 🧪 Testing

### 1. Run the App

```bash
flutter pub get
flutter run
```

### 2. Test Notification Flow

1. **Create two test accounts** (User A and User B)
2. **User A creates a post**
3. **User B comments on User A's post**
4. **User A should receive notification** ✅
5. **User A replies to User B's comment**
6. **User B should receive notification** ✅

### 3. Debug with FCM Token

Check logs for:
```
✅ FCM Token: xxxxxxxxxxxxxxxxxxxxxx
```

Copy this token and test manually in Firebase Console:
1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Paste the token
4. Send test notification

## 📊 Firestore Structure

### Users Collection

```javascript
users/{userId}
  ├── fcmToken: "xxxxx"              // FCM device token
  ├── lastTokenUpdate: Timestamp     // Last token refresh
  └── notify_me: true                // User notification preference
```

### Notifications Queue

```javascript
notifications/{notificationId}
  ├── token: "xxxxx"                 // Recipient FCM token
  ├── notification: {
  │     title: "New Comment"
  │     body: "John commented: ..."
  │   }
  ├── data: {
  │     type: "comment" | "reply"
  │     postId: "xxxxx"
  │     commenterId: "xxxxx"
  │   }
  ├── createdAt: Timestamp
  ├── sent: false                    // Processed by Cloud Function
  └── sentAt: Timestamp (optional)   // When notification was sent
```

## 🔧 Troubleshooting

### Notifications not received?

1. **Check FCM token is saved**
   ```dart
   final token = await NotificationService().fcmToken;
   print('Token: $token');
   ```

2. **Check Firestore permissions**
   - Users must be able to read/write their own `fcmToken`
   - Cloud Function needs permission to read notifications collection

3. **Check Cloud Function logs**
   ```bash
   firebase functions:log
   ```

4. **Check notification permissions**
   - Android: Settings → Apps → CampusWhisper → Notifications
   - iOS: Settings → CampusWhisper → Notifications

### Cloud Function errors?

1. **Check function deployment**
   ```bash
   firebase deploy --only functions
   ```

2. **Check function logs**
   ```bash
   firebase functions:log --only sendNotification
   ```

3. **Test function locally**
   ```bash
   cd functions
   npm run serve
   ```

## 🔐 Security Rules

Update Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can update their own FCM token
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Anyone authenticated can create notifications
    match /notifications/{notificationId} {
      allow create: if request.auth != null;
      allow read, update: if false; // Only Cloud Functions can read/update
    }
  }
}
```

## 📝 Usage in Code

### Send notification when commenting

```dart
// Automatically sent by CommentProvider
await commentProvider.submitComment(
  context: context,
  postId: postId,
  userId: userId,
  authorName: userName,
  onCommentCreated: () async {
    // Notifications sent automatically
  },
);
```

### Manually send notification

```dart
await NotificationService().sendCommentNotification(
  postId: 'post123',
  postOwnerId: 'user456',
  commenterName: 'John Doe',
  commentText: 'Great post!',
);
```

## 🚀 Performance Tips

1. **Notification queue is cleaned automatically** (7 days)
2. **Use Firestore indexing** for faster queries
3. **Batch notifications** if sending multiple
4. **Check `notify_me` preference** before sending

## 📚 Resources

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Functions](https://firebase.google.com/docs/functions)

## ✅ Checklist

- [ ] Added `google-services.json` (Android)
- [ ] Added `GoogleService-Info.plist` (iOS)
- [ ] Updated AndroidManifest.xml
- [ ] Enabled Push Notifications in Xcode
- [ ] Deployed Cloud Functions
- [ ] Updated Firestore security rules
- [ ] Tested notification flow
- [ ] Verified FCM tokens are saved
- [ ] Checked notification permissions

---

**Need help?** Check the [Firebase Console](https://console.firebase.google.com) or create an issue.
