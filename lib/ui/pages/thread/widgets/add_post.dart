import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';

import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/default_button.dart';

class AddPost extends StatefulWidget {
  final List<String> tags;
  final Function(Map<String, dynamic>) onPostCreated;

  const AddPost({super.key, required this.tags, required this.onPostCreated});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _contentController = TextEditingController();
  String? _selectedTag;
  final bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter post content')),
      );
      return;
    }

    if (_selectedTag == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a tag')));
      return;
    }

    // Create new post
    final newPost = {
      'firstName': 'Current',
      'lastName': 'User',
      'userName': 'Current User',
      'content': _contentController.text.trim(),
      'tag': _selectedTag,
      'time': 'Just now',
      'upvoteCount': 0,
      'downvoteCount': 0,
      'commentCount': 0,
    };

    widget.onPostCreated(newPost);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomInput(
          controller: _contentController,
          fieldLabel: 'What\'s on your mind?',
          hintText: 'Share your thoughts with the campus...',
          validation: false,
          errorMessage: '',
          maxLines: 5,
          minLines: 3,
          autofocus: false,
          textInputAction: TextInputAction.newline,
          inputType: TextInputType.multiline,
        ),
        AppDimensions.h16,
        CustomDropdown<String>(
          fieldLabel: 'Select Tag',
          hintText: 'Choose a category',
          validation: true,
          errorMessage: 'Please select a tag',

          items: widget.tags
              .map((tag) => DropdownItem(value: tag, text: tag))
              .toList(),
          selectedValue: _selectedTag,
          onChanged: (value) {
            setState(() {
              _selectedTag = value;
            });
          },
        ),
        AppDimensions.h24,
        DefaultButton(
          text: 'Post',
          press: _handleSubmit,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
