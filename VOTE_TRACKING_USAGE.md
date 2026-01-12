# Vote and Comment Tracking - Usage Guide

This guide explains how to track votes and comments on posts in the CampusWhisper app.

## Important Note

**Votes are now stored as subcollections under posts, not as a standalone collection.**

This means:
- ✅ Use `PostRepository` and `PostProvider` for all vote operations
- ❌ Do NOT use `GameRepository` for votes (vote methods have been removed)
- ✅ Each user can only have one vote per post (userId is the document ID in the subcollection)
- ✅ Vote tracking is built into post operations

## Architecture Overview

```
UI Layer (Widgets)
    ↓
Provider Layer (PostProvider)
    ↓
Repository Layer (PostRepository)
    ↓
Firestore Database
    - posts/{postId}
        - Main post data (upvote_count, downvote_count, comment_count)
        - Subcollection: votes/{userId}
            - user_id: string
            - vote_type: "upvote" or "downvote"
            - created_at: timestamp
        - Subcollection: comments/{commentId}
            - Uses CommentModel structure
```

## Models

### VoteModel
```dart
class VoteModel {
  final String userId;
  final String voteType;  // "upvote" or "downvote"
  final DateTime createdAt;

  // Helper getters
  bool get isUpvote => voteType == 'upvote';
  bool get isDownvote => voteType == 'downvote';
}
```

## Usage Examples

### 1. Voting on a Post

```dart
import 'package:provider/provider.dart';
import 'package:campuswhisper/providers/post_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Column(
      children: [
        // Upvote button
        IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () async {
            await postProvider.upvotePost(post.postId, currentUserId);
          },
        ),

        Text('${post.upvoteCount}'),

        // Downvote button
        IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () async {
            await postProvider.downvotePost(post.postId, currentUserId);
          },
        ),

        Text('${post.downvoteCount}'),
      ],
    );
  }
}
```

### 2. Checking User's Current Vote

```dart
Future<void> checkUserVote(String postId, String userId) async {
  final postProvider = Provider.of<PostProvider>(context, listen: false);

  final userVote = await postProvider.getUserVote(postId, userId);

  if (userVote == 'upvote') {
    print('User has upvoted this post');
  } else if (userVote == 'downvote') {
    print('User has downvoted this post');
  } else {
    print('User has not voted on this post');
  }
}
```

### 3. Getting List of Upvoters/Downvoters

```dart
Future<void> showVotersList(String postId) async {
  final postProvider = Provider.of<PostProvider>(context, listen: false);

  // Get all upvoters
  final upvoters = await postProvider.getUpvoters(postId);
  print('Upvoters: ${upvoters.length}');
  for (var vote in upvoters) {
    print('User ${vote.userId} upvoted at ${vote.createdAt}');
  }

  // Get all downvoters
  final downvoters = await postProvider.getDownvoters(postId);
  print('Downvoters: ${downvoters.length}');

  // Get all votes (both upvotes and downvotes)
  final allVotes = await postProvider.getVotes(postId);
  print('Total votes: ${allVotes.length}');
}
```

### 4. Adding a Comment

```dart
Future<void> addCommentToPost(String postId) async {
  final postProvider = Provider.of<PostProvider>(context, listen: false);
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) return;

  final comment = CommentModel(
    id: FirebaseFirestore.instance.collection('comments').doc().id,
    parentId: postId,
    parentType: 'post',
    authorId: currentUser.uid,
    authorName: currentUser.displayName ?? 'Anonymous',
    content: 'This is my comment',
    createdAt: DateTime.now(),
  );

  await postProvider.addComment(context, postId, comment);
}
```

### 5. Getting Comments for a Post

```dart
Future<void> loadComments(String postId) async {
  final postProvider = Provider.of<PostProvider>(context, listen: false);

  final comments = await postProvider.getComments(postId);

  print('Total comments: ${comments.length}');
  for (var comment in comments) {
    print('${comment.authorName}: ${comment.content}');
  }
}
```

### 6. Complete Post Widget with Voting and Comments

```dart
class CompletePostWidget extends StatefulWidget {
  final PostModel post;

  @override
  _CompletePostWidgetState createState() => _CompletePostWidgetState();
}

class _CompletePostWidgetState extends State<CompletePostWidget> {
  String? currentUserVote;
  List<CommentModel> comments = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Load user's vote
    final vote = await postProvider.getUserVote(widget.post.postId, currentUserId);

    // Load comments
    final loadedComments = await postProvider.getComments(widget.post.postId);

    setState(() {
      currentUserVote = vote;
      comments = loadedComments;
    });
  }

  Future<void> _handleUpvote() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    await postProvider.upvotePost(widget.post.postId, currentUserId);
    await _loadData(); // Reload to get updated vote status
  }

  Future<void> _handleDownvote() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    await postProvider.downvotePost(widget.post.postId, currentUserId);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Post content
          Text(widget.post.content),

          // Vote buttons
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  color: currentUserVote == 'upvote' ? Colors.green : null,
                ),
                onPressed: _handleUpvote,
              ),
              Text('${widget.post.upvoteCount}'),

              IconButton(
                icon: Icon(
                  Icons.arrow_downward,
                  color: currentUserVote == 'downvote' ? Colors.red : null,
                ),
                onPressed: _handleDownvote,
              ),
              Text('${widget.post.downvoteCount}'),

              SizedBox(width: 16),
              Icon(Icons.comment),
              Text('${widget.post.commentCount}'),
            ],
          ),

          // Comments list
          ...comments.map((comment) => ListTile(
            title: Text(comment.authorName),
            subtitle: Text(comment.content),
          )),
        ],
      ),
    );
  }
}
```

## Database Structure

### Firestore Structure:
```
posts/
  {postId}/
    - post_id: string
    - type: string
    - created_by: string
    - content: string
    - upvote_count: number (aggregate)
    - downvote_count: number (aggregate)
    - comment_count: number (aggregate)

    votes/ (subcollection)
      {userId}/  ← Document ID is the user ID
        - user_id: string
        - vote_type: "upvote" | "downvote"
        - created_at: timestamp

    comments/ (subcollection)
      {commentId}/
        - id: string
        - parent_id: string
        - parent_type: string
        - author_id: string
        - author_name: string
        - content: string
        - created_at: timestamp
```

## Key Features

1. **One Vote Per User**: Each user can only have one vote per post (stored with userId as document ID)
2. **Vote Toggle**: Clicking upvote when already upvoted removes the upvote
3. **Vote Switch**: Clicking downvote when already upvoted switches from upvote to downvote
4. **Aggregate Counts**: Post document maintains counts for efficient querying
5. **Atomic Updates**: Uses Firestore transactions to ensure data consistency
6. **Optimistic UI**: Provider updates UI immediately before server confirmation
7. **Comment Tracking**: Automatically maintains comment_count on post document

## Notes

- All vote and comment operations are transactional to prevent race conditions
- The provider includes optimistic UI updates for better user experience
- Vote counts are denormalized on the post document for efficient querying
- User IDs are stored in votes to allow querying "who voted on this post"
- Comments are stored in a subcollection for better scalability
