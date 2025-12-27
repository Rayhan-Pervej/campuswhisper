import 'package:campuswhisper/ui/widgets/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../widgets/custom_bottom_dialog.dart';
import 'widgets/add_post.dart';
import 'widgets/tag_chip_filter.dart';
import 'widgets/thread_card.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  String? _selectedTag;
  final List<String> _tags = [
    'Food & Dining',
    'Academics',
    'Campus Life',
    'Events',
    'Housing',
    'Sports',
    'Technology',
    'Career',
    'Health',
    'Transportation',
  ];

  final List<Map<String, dynamic>> _allThreads = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'userName': 'John Doe',
      'content':
          'Just heard that the cafeteria is introducing new vegan options next week! Finally some good news for us plant-based eaters 🌱',
      'tag': 'Food & Dining',
      'time': '2d ago',
      'upvoteCount': 24,
      'downvoteCount': 2,
      'commentCount': 8,
    },
    {
      'firstName': 'Sarah',
      'lastName': 'Smith',
      'userName': 'Sarah Smith',
      'content':
          'Does anyone know when the library extends its hours during finals week? I can\'t find the info on the website.',
      'tag': 'Academics',
      'time': '5h ago',
      'upvoteCount': 15,
      'downvoteCount': 0,
      'commentCount': 12,
    },
    {
      'firstName': 'Mike',
      'lastName': 'Johnson',
      'userName': 'Mike Johnson',
      'content':
          'Pro tip: Professor Anderson\'s office hours are way more helpful than the TA sessions. He actually takes time to explain concepts thoroughly.',
      'tag': 'Campus Life',
      'time': '1d ago',
      'upvoteCount': 45,
      'downvoteCount': 3,
      'commentCount': 23,
    },
    {
      'firstName': 'Emily',
      'lastName': 'Davis',
      'userName': 'Emily Davis',
      'content':
          'The basketball game tonight is going to be amazing! Don\'t miss it!',
      'tag': 'Sports',
      'time': '3h ago',
      'upvoteCount': 32,
      'downvoteCount': 1,
      'commentCount': 15,
    },
    {
      'firstName': 'Alex',
      'lastName': 'Brown',
      'userName': 'Alex Brown',
      'content':
          'Anyone interested in forming a study group for the upcoming CS midterm?',
      'tag': 'Academics',
      'time': '6h ago',
      'upvoteCount': 18,
      'downvoteCount': 0,
      'commentCount': 9,
    },
  ];

  List<Map<String, dynamic>> get _filteredThreads {
    if (_selectedTag == null) {
      return _allThreads;
    }
    return _allThreads
        .where((thread) => thread['tag'] == _selectedTag)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: TagChipFilter(
                tags: _tags,
                selectedTag: _selectedTag,
                onTagSelected: (tag) {
                  setState(() {
                    _selectedTag = tag;
                  });
                },
              ),
            ),

            ..._filteredThreads.map((thread) {
              return ThreadCard(
                firstName: thread['firstName'],
                lastName: thread['lastName'],
                userName: thread['userName'],
                content: thread['content'],
                tag: thread['tag'],
                time: thread['time'],
                upvoteCount: thread['upvoteCount'],
                downvoteCount: thread['downvoteCount'],
                commentCount: thread['commentCount'],
                onUpvote: () {
                  print('Upvote clicked');
                },
                onDownvote: () {
                  print('Downvote clicked');
                },
                onComment: () {
                  print('Comment clicked');
                },
              );
            }),
            AppDimensions.h12,
          ],
        ),
      ),
      // floatingActionButton: SizedBox(
      //   height: AppDimensions.space40 * 1.5,
      //   width: AppDimensions.space40 * 1.5,
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       CustomBottomDialog.show(
      //         context: context,
      //         title: 'Create New Post',
      //         child: AddPost(
      //           tags: _tags,
      //           onPostCreated: (newPost) {
      //             setState(() {
      //               _allThreads.insert(0, newPost);
      //             });
      //             ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text('Post created successfully!')),
      //             );
      //           },
      //         ),
      //       );
      //     },

      //     backgroundColor: colorScheme.primaryContainer,

      //     child: Icon(
      //       Iconsax.add_outline,
      //       color: colorScheme.primary,
      //       size: AppDimensions.space40,
      //     ),
      //   ),
      // ),
    );
  }
}
