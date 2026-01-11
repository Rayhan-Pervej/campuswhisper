import 'dart:math';
import 'package:campuswhisper/models/posts_model.dart';
import 'package:campuswhisper/models/event_model.dart';
import 'package:campuswhisper/models/competition_model.dart';
import 'package:campuswhisper/models/club_model.dart';
import 'package:campuswhisper/models/lost_found_item_model.dart';
import 'package:campuswhisper/models/comment_model.dart';
import 'package:campuswhisper/repository/post_repository.dart';
import 'package:campuswhisper/repository/event_repository.dart';
import 'package:campuswhisper/repository/competition_repository.dart';
import 'package:campuswhisper/repository/club_repository.dart';
import 'package:campuswhisper/repository/lost_found_repository.dart';
import 'package:campuswhisper/repository/comment_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DummyDataService {
  final PostRepository _postRepository = PostRepository();
  final EventRepository _eventRepository = EventRepository();
  final CompetitionRepository _competitionRepository = CompetitionRepository();
  final ClubRepository _clubRepository = ClubRepository();
  final LostFoundRepository _lostFoundRepository = LostFoundRepository();
  final CommentRepository _commentRepository = CommentRepository();

  final Random _random = Random();

  // Sample data arrays
  final List<String> _userIds = ['user1', 'user2', 'user3', 'user4', 'user5'];
  final List<String> _userNames = [
    'Alice Johnson',
    'Bob Smith',
    'Charlie Davis',
    'Diana Wilson',
    'Ethan Brown'
  ];

  final List<String> _eventCategories = [
    'Academic',
    'Cultural',
    'Sports',
    'Workshop',
    'Seminar'
  ];

  final List<String> _competitionCategories = [
    'Programming',
    'Design',
    'Business',
    'Sports',
    'Gaming'
  ];

  final List<String> _clubCategories = [
    'Academic',
    'Cultural',
    'Sports',
    'Social',
    'Technology'
  ];

  final List<String> _lostFoundCategories = [
    'Electronics',
    'Documents',
    'Accessories',
    'Books',
    'Keys'
  ];

  final List<String> _locations = [
    'Main Building',
    'Library',
    'Cafeteria',
    'Sports Complex',
    'Auditorium',
    'Lab Building',
    'Parking Lot'
  ];

  // ═══════════════════════════════════════════════════════════════
  // MAIN METHOD - Add all dummy data
  // ═══════════════════════════════════════════════════════════════

  Future<Map<String, int>> addAllDummyData() async {
    int postsAdded = 0;
    int eventsAdded = 0;
    int competitionsAdded = 0;
    int clubsAdded = 0;
    int lostFoundAdded = 0;
    int commentsAdded = 0;

    try {
      // Add Posts
      final posts = _generatePosts(30);
      for (var post in posts) {
        await _postRepository.create(post);
        postsAdded++;
      }

      // Add Events
      final events = _generateEvents(15);
      for (var event in events) {
        await _eventRepository.create(event);
        eventsAdded++;
      }

      // Add Competitions
      final competitions = _generateCompetitions(10);
      for (var competition in competitions) {
        await _competitionRepository.create(competition);
        competitionsAdded++;
      }

      // Add Clubs
      final clubs = _generateClubs(8);
      for (var club in clubs) {
        await _clubRepository.create(club);
        clubsAdded++;
      }

      // Add Lost & Found Items
      final lostFoundItems = _generateLostFoundItems(15);
      for (var item in lostFoundItems) {
        await _lostFoundRepository.create(item);
        lostFoundAdded++;
      }

      // Add Comments (for posts)
      if (posts.isNotEmpty) {
        final comments = _generateComments(posts, 20);
        for (var comment in comments) {
          await _commentRepository.create(comment);
          commentsAdded++;
        }
      }

      return {
        'posts': postsAdded,
        'events': eventsAdded,
        'competitions': competitionsAdded,
        'clubs': clubsAdded,
        'lostFound': lostFoundAdded,
        'comments': commentsAdded,
      };
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE ALL DATA (for cleanup)
  // ═══════════════════════════════════════════════════════════════

  Future<void> deleteAllDummyData() async {
    final firestore = FirebaseFirestore.instance;

    // Delete all collections
    await _deleteCollection(firestore, 'posts');
    await _deleteCollection(firestore, 'events');
    await _deleteCollection(firestore, 'competitions');
    await _deleteCollection(firestore, 'clubs');
    await _deleteCollection(firestore, 'lost_found_items');
    await _deleteCollection(firestore, 'comments');
  }

  Future<void> _deleteCollection(
      FirebaseFirestore firestore, String collectionName) async {
    final snapshot = await firestore.collection(collectionName).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE POSTS
  // ═══════════════════════════════════════════════════════════════

  List<PostModel> _generatePosts(int count) {
    final posts = <PostModel>[];
    final types = ['Question', 'Discussion', 'Announcement'];
    final titles = [
      'Need help with Data Structures',
      'Best place to study on campus?',
      'Lost my ID card',
      'Looking for study group',
      'Important: Exam schedule updated',
      'Anyone interested in a coding bootcamp?',
      'Tips for final exams?',
      'Campus wifi issues',
      'Scholarship opportunities',
      'How to improve programming skills?',
    ];

    final contents = [
      'I\'m struggling with binary trees. Can someone explain how traversal works?',
      'The library is always crowded. Where else can we study peacefully?',
      'I lost my student ID near the cafeteria yesterday. Please contact if found.',
      'Looking for people to form a study group for Database course.',
      'The final exam schedule has been updated. Check the notice board.',
      'Anyone interested in joining a weekend coding bootcamp? Reply below!',
      'Finals are coming up. Share your best study tips here!',
      'Is anyone else experiencing slow wifi in the main building?',
      'There are some great scholarship opportunities available. DM for details.',
      'What are the best resources to improve coding skills? Share your favorites!',
    ];

    for (int i = 0; i < count; i++) {
      final userIndex = _random.nextInt(_userIds.length);
      final titleIndex = _random.nextInt(titles.length);
      final daysAgo = _random.nextInt(30);

      posts.add(PostModel(
        postId: 'post_${i + 1}',
        type: types[_random.nextInt(types.length)],
        createdBy: _userIds[userIndex],
        content: contents[_random.nextInt(contents.length)],
        title: titles[titleIndex],
        createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
        upvoteCount: _random.nextInt(50),
        downvoteCount: _random.nextInt(10),
      ));
    }

    return posts;
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE EVENTS
  // ═══════════════════════════════════════════════════════════════

  List<EventModel> _generateEvents(int count) {
    final events = <EventModel>[];
    final titles = [
      'Tech Talk: AI in Education',
      'Annual Sports Day',
      'Cultural Night 2026',
      'Workshop: Web Development',
      'Guest Lecture: Industry Trends',
      'Freshers Welcome Party',
      'Career Fair 2026',
      'Hackathon: Code for Change',
      'Music Concert',
      'Photography Exhibition',
    ];

    final descriptions = [
      'Join us for an insightful session on AI applications in modern education.',
      'Annual sports competition featuring various indoor and outdoor games.',
      'Celebrate diversity with performances from students across departments.',
      'Learn modern web development from industry experts.',
      'Industry leaders discuss current trends and future opportunities.',
      'Welcome event for new students with games and entertainment.',
      'Meet recruiters from top companies and explore career opportunities.',
      '48-hour coding marathon to solve real-world problems.',
      'Live performances by student bands and artists.',
      'Showcase of stunning photography by campus photographers.',
    ];

    for (int i = 0; i < count; i++) {
      final userIndex = _random.nextInt(_userIds.length);
      final titleIndex = _random.nextInt(titles.length);
      final daysFromNow = _random.nextInt(60) - 10; // Past and future events

      events.add(EventModel(
        id: 'event_${i + 1}',
        title: titles[titleIndex],
        description: descriptions[_random.nextInt(descriptions.length)],
        category: _eventCategories[_random.nextInt(_eventCategories.length)],
        location: _locations[_random.nextInt(_locations.length)],
        eventDate: DateTime.now().add(Duration(days: daysFromNow)),
        organizerId: _userIds[userIndex],
        organizerName: _userNames[userIndex],
        attendeeIds: _getRandomUserIds(_random.nextInt(20)),
        maxAttendees: 50 + _random.nextInt(150),
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ));
    }

    return events;
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE COMPETITIONS
  // ═══════════════════════════════════════════════════════════════

  List<CompetitionModel> _generateCompetitions(int count) {
    final competitions = <CompetitionModel>[];
    final titles = [
      'Code Sprint 2026',
      'Design Challenge',
      'Business Plan Competition',
      'Chess Tournament',
      'E-Sports Championship',
      'Debate Competition',
      'Innovation Challenge',
      'Quiz Bowl',
    ];

    final descriptions = [
      'Test your coding skills in this intense programming competition.',
      'Create the best UI/UX design for a mobile app.',
      'Present your innovative business idea and win prizes.',
      'Show your strategic thinking in this campus chess tournament.',
      'Compete in popular games like Valorant and PUBG.',
      'Engage in thought-provoking debates on current topics.',
      'Solve real-world problems with innovative solutions.',
      'Test your general knowledge across various topics.',
    ];

    final prizes = [
      '1st: \$500, 2nd: \$300, 3rd: \$100',
      '1st: \$1000, 2nd: \$500, 3rd: \$250',
      'Winner gets seed funding and mentorship',
      'Trophy and certificates for top 3',
      '1st: Gaming gear worth \$800',
    ];

    for (int i = 0; i < count; i++) {
      final userIndex = _random.nextInt(_userIds.length);
      final titleIndex = _random.nextInt(titles.length);
      final daysFromNow = _random.nextInt(40) + 5;
      final regDeadlineDays = _random.nextInt(daysFromNow - 2) + 2;

      competitions.add(CompetitionModel(
        id: 'comp_${i + 1}',
        title: titles[titleIndex],
        description: descriptions[_random.nextInt(descriptions.length)],
        category:
            _competitionCategories[_random.nextInt(_competitionCategories.length)],
        organizerId: _userIds[userIndex],
        organizerName: _userNames[userIndex],
        registrationDeadline:
            DateTime.now().add(Duration(days: regDeadlineDays)),
        competitionDate: DateTime.now().add(Duration(days: daysFromNow)),
        location: _locations[_random.nextInt(_locations.length)],
        prizes: prizes[_random.nextInt(prizes.length)],
        participantIds: _getRandomUserIds(_random.nextInt(15)),
        maxParticipants: 30 + _random.nextInt(70),
        status: 'Upcoming',
        isTeamBased: _random.nextBool(),
        teamSize: _random.nextBool() ? _random.nextInt(3) + 2 : null,
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ));
    }

    return competitions;
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE CLUBS
  // ═══════════════════════════════════════════════════════════════

  List<ClubModel> _generateClubs(int count) {
    final clubs = <ClubModel>[];
    final names = [
      'Coding Club',
      'Photography Society',
      'Drama Club',
      'Robotics Club',
      'Literary Society',
      'Music Club',
      'Entrepreneurship Cell',
      'Gaming Club',
    ];

    final descriptions = [
      'Learn, code, and build amazing projects together.',
      'Capture moments and improve photography skills.',
      'Express yourself through theater and drama.',
      'Build robots and explore automation.',
      'Discuss literature, poetry, and creative writing.',
      'Learn instruments and perform live.',
      'Turn your business ideas into reality.',
      'Connect with fellow gamers and compete.',
    ];

    for (int i = 0; i < count; i++) {
      final userIndex = _random.nextInt(_userIds.length);
      final nameIndex = i < names.length ? i : _random.nextInt(names.length);

      clubs.add(ClubModel(
        id: 'club_${i + 1}',
        name: names[nameIndex],
        description: descriptions[_random.nextInt(descriptions.length)],
        category: _clubCategories[_random.nextInt(_clubCategories.length)],
        presidentId: _userIds[userIndex],
        presidentName: _userNames[userIndex],
        memberIds: _getRandomUserIds(_random.nextInt(30) + 10),
        adminIds: _getRandomUserIds(_random.nextInt(3) + 1),
        contactEmail: 'club${i + 1}@campus.edu',
        contactPhone: '+1-555-${_random.nextInt(9000) + 1000}',
        establishedDate: DateTime.now().subtract(Duration(days: _random.nextInt(365) + 365)),
        createdAt: DateTime.now().subtract(Duration(days: 10)),
      ));
    }

    return clubs;
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE LOST & FOUND ITEMS
  // ═══════════════════════════════════════════════════════════════

  List<LostFoundItemModel> _generateLostFoundItems(int count) {
    final items = <LostFoundItemModel>[];
    final itemNames = [
      'iPhone 13',
      'Student ID Card',
      'Black Backpack',
      'Water Bottle',
      'Laptop Charger',
      'Car Keys',
      'Textbook',
      'Calculator',
      'Earphones',
      'Notebook',
    ];

    final descriptions = [
      'Blue case with a small scratch on the back.',
      'Name: John Doe, Department: Computer Science',
      'Contains notebooks and a pencil case.',
      'Stainless steel, with university logo.',
      'Dell laptop charger, 65W.',
      'Toyota keychain attached.',
      'Data Structures and Algorithms, 5th edition.',
      'Scientific calculator, Casio brand.',
      'White Apple AirPods.',
      'Red spiral notebook with math notes.',
    ];

    for (int i = 0; i < count; i++) {
      final userIndex = _random.nextInt(_userIds.length);
      final itemIndex = _random.nextInt(itemNames.length);
      final daysAgo = _random.nextInt(14) + 1;
      final isLost = _random.nextBool();

      items.add(LostFoundItemModel(
        id: 'item_${i + 1}',
        itemName: itemNames[itemIndex],
        description: descriptions[_random.nextInt(descriptions.length)],
        type: isLost ? 'Lost' : 'Found',
        category:
            _lostFoundCategories[_random.nextInt(_lostFoundCategories.length)],
        location: _locations[_random.nextInt(_locations.length)],
        date: DateTime.now().subtract(Duration(days: daysAgo)),
        posterId: _userIds[userIndex],
        posterName: _userNames[userIndex],
        contactInfo: _userNames[userIndex].split(' ')[0].toLowerCase() + '@campus.edu',
        status: _random.nextDouble() > 0.3 ? 'Active' : 'Resolved',
        createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
      ));
    }

    return items;
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE COMMENTS
  // ═══════════════════════════════════════════════════════════════

  List<CommentModel> _generateComments(List<PostModel> posts, int count) {
    final comments = <CommentModel>[];
    final commentTexts = [
      'Great post! Thanks for sharing.',
      'I completely agree with this.',
      'This is really helpful, thank you!',
      'Does anyone have more info on this?',
      'I had the same issue, here\'s what worked for me...',
      'Interesting perspective!',
      'Can you elaborate more on this?',
      'Thanks for the update!',
      'This is exactly what I was looking for.',
      'Very informative, keep it up!',
    ];

    for (int i = 0; i < count && posts.isNotEmpty; i++) {
      final userIndex = _random.nextInt(_userIds.length);
      final post = posts[_random.nextInt(posts.length)];
      final hoursAgo = _random.nextInt(24 * 7);

      comments.add(CommentModel(
        id: 'comment_${i + 1}',
        parentId: post.postId,
        parentType: 'post',
        content: commentTexts[_random.nextInt(commentTexts.length)],
        authorId: _userIds[userIndex],
        authorName: _userNames[userIndex],
        upvotes: _random.nextInt(20),
        downvotes: _random.nextInt(5),
        createdAt: DateTime.now().subtract(Duration(hours: hoursAgo)),
      ));
    }

    return comments;
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  List<String> _getRandomUserIds(int count) {
    final userIds = <String>[];
    for (int i = 0; i < count; i++) {
      userIds.add(_userIds[_random.nextInt(_userIds.length)]);
    }
    return userIds.toSet().toList(); // Remove duplicates
  }
}
