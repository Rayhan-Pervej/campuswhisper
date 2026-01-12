# Firebase Configuration Files Setup

## ⚠️ Important: Download Required Files from Firebase Console

The notification system requires Firebase configuration files that contain your project-specific credentials. You need to download these from the Firebase Console.

## 📱 Android Setup

### 1. Download google-services.json

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Click on the gear icon ⚙️ (Project Settings)
4. Scroll down to "Your apps"
5. Click on your Android app (or add one if not exists)
6. Download `google-services.json`
7. Place it in: `android/app/google-services.json`

**File structure:**
```
android/
  └── app/
      ├── build.gradle
      └── google-services.json  ← Place here
```

### 2. Verify android/app/build.gradle

Make sure your `android/app/build.gradle` has:

```gradle
apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services'  // Add this line

android {
    defaultConfig {
        minSdkVersion 21  // FCM requires minimum API 21
    }
}

dependencies {
    // ... other dependencies
}
```

### 3. Verify android/build.gradle

Make sure your `android/build.gradle` has:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'  // Add this line
    }
}
```

## 🍎 iOS Setup (Optional - for iOS support)

### 1. Download GoogleService-Info.plist

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Click on Project Settings
4. Scroll to "Your apps"
5. Click on your iOS app (or add one if not exists)
6. Download `GoogleService-Info.plist`
7. Open `ios/Runner.xcworkspace` in Xcode
8. Drag `GoogleService-Info.plist` into the Runner folder
9. Make sure "Copy items if needed" is checked

### 2. Enable Push Notifications in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to "Signing & Capabilities"
4. Click "+ Capability"
5. Add "Push Notifications"
6. Add "Background Modes"
7. Check "Remote notifications"

### 3. Upload APNs Certificate

1. Generate APNs key in Apple Developer Console
2. Go to Firebase Console → Project Settings → Cloud Messaging → iOS
3. Upload your APNs authentication key

## ☁️ Deploy Cloud Functions

### 1. Install Firebase CLI

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Initialize Firebase in your project

```bash
cd "d:\CodeFode\Flutter Project\campuswhisper"
firebase init
```

Select:
- **Functions**: Configure a Cloud Functions directory and its files
- Choose "Use an existing project"
- Select JavaScript
- Install dependencies with npm

### 4. Deploy Functions

```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

## 🔐 Update Firestore Security Rules

Go to Firebase Console → Firestore Database → Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can read/write their own data
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;

      // Allow users to update their FCM token
      allow update: if request.auth != null
        && request.auth.uid == userId
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['fcmToken', 'lastTokenUpdate']);
    }

    // Posts
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.createdBy;

      // Comments subcollection
      match /comments/{commentId} {
        allow read: if request.auth != null;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && request.auth.uid == resource.data.authorId;

        // Votes subcollection
        match /votes/{userId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }

    // Notifications (only Cloud Functions can read/update)
    match /notifications/{notificationId} {
      allow create: if request.auth != null;
      allow read, update, delete: if false;  // Only Cloud Functions
    }
  }
}
```

## ✅ Verification Checklist

- [ ] `google-services.json` placed in `android/app/`
- [ ] `android/app/build.gradle` updated with google-services plugin
- [ ] `android/build.gradle` has google-services classpath
- [ ] `AndroidManifest.xml` has FCM metadata (already done ✅)
- [ ] `colors.xml` created (already done ✅)
- [ ] Cloud Functions deployed
- [ ] Firestore security rules updated
- [ ] Tested on physical device (not emulator for push notifications)

## 🧪 Testing

1. **Run the app on a physical device** (emulators may not receive push notifications reliably)

```bash
flutter run
```

2. **Check logs for FCM token:**

```
✅ FCM Token: xxxxxxxxxxxxxxxxxxxxxx
✅ FCM token saved to Firestore
```

3. **Test the flow:**
   - Create two test accounts
   - User A creates a post
   - User B comments on the post
   - User A should receive a notification! 🔔

4. **Manual test via Firebase Console:**
   - Copy the FCM token from logs
   - Go to Firebase Console → Cloud Messaging
   - Click "Send your first message"
   - Paste the token and send

## 🔧 Troubleshooting

### "google-services.json not found"
- Ensure file is in `android/app/google-services.json`
- Rebuild the project: `flutter clean && flutter pub get`

### "No Firebase App '[DEFAULT]' has been created"
- Ensure `google-services.json` is properly configured
- Check that Firebase is initialized in `main.dart` (already done ✅)

### Notifications not appearing
- Check notification permissions in device settings
- Ensure app is in background/killed (foreground notifications shown differently)
- Check Cloud Function logs: `firebase functions:log`
- Verify FCM token is saved in Firestore

### Cloud Function errors
- Check function logs: `firebase functions:log --only sendNotification`
- Ensure Firestore permissions allow Cloud Functions to read notifications
- Verify the function is deployed: `firebase deploy --only functions`

## 📚 Additional Resources

- [Firebase Console](https://console.firebase.google.com)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [FCM Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Cloud Functions Documentation](https://firebase.google.com/docs/functions)

---

**Note:** After adding the Firebase configuration files, rebuild your app completely:

```bash
flutter clean
flutter pub get
flutter run
```
