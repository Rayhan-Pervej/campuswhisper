# Adding Test Data to Firestore

## Quick Setup for Testing Thread Page

### Step 1: Open Firebase Console
1. Go to https://console.firebase.google.com
2. Select your `campuswhisper` project
3. Click on **Firestore Database** in the left sidebar

### Step 2: Add a Test Post

Click **Start collection** (or add to existing `posts` collection):

**Collection ID:** `posts`

**Document (Auto-ID)**

Add these fields:

```
post_id: (same as auto-generated document ID)
type: "question"  (string)
created_by: "test_user_123"  (string)
created_by_name: "John Doe"  (string)
content: "This is my first test post! Does anyone know when the cafeteria opens?"  (string)
created_at: (Click "Add field" → Select Timestamp → "Use current date")
upvote_count: 0  (number)
downvote_count: 0  (number)
comment_count: 0  (number)
```

### Step 3: Add More Test Posts (Optional)

Repeat with different content:

**Post 2:**
```
type: "discussion"
created_by_name: "Jane Smith"
content: "Let's discuss the upcoming tech fest..."
```

**Post 3:**
```
type: "announcement"
created_by_name: "Admin User"
content: "Important: Campus will be closed on Friday"
```

### Step 4: Test in Your App

1. Run your Flutter app
2. Navigate to Thread Page
3. You should see your posts!
4. Try voting on them
5. Try filtering by tags

---

## Alternative: Use Firebase CLI to Add Bulk Data

If you have Firebase CLI installed, you can import JSON data:

```json
{
  "posts": {
    "post1": {
      "post_id": "post1",
      "type": "question",
      "created_by": "user123",
      "created_by_name": "John Doe",
      "content": "How do I submit assignments online?",
      "created_at": {"_seconds": 1736726400, "_nanoseconds": 0},
      "upvote_count": 5,
      "downvote_count": 1,
      "comment_count": 3
    }
  }
}
```

---

## Troubleshooting

**"Name is blank"**
- Make sure `created_by_name` field exists in your post document
- Check that UserProvider has loaded the current user data

**"Voting doesn't work"**
- Check Firebase Console → Firestore → Rules
- Make sure rules allow read/write:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**"Posts not showing"**
- Check that you're logged in (Firebase Auth)
- Check console logs for errors
- Verify collection name is exactly "posts" (lowercase)
