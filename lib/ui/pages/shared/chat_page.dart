import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:icons_plus/icons_plus.dart';

class ChatPage extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String? recipientAvatarUrl;

  const ChatPage({
    super.key,
    required this.recipientId,
    required this.recipientName,
    this.recipientAvatarUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  // Sample messages - will be replaced with real data
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'senderId': 'other',
      'text': 'Hi! I saw your post about the lost phone.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isSent': true,
      'isRead': true,
    },
    {
      'id': '2',
      'senderId': 'me',
      'text': 'Hey! Yes, I found it near the library.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 28)),
      'isSent': true,
      'isRead': true,
    },
    {
      'id': '3',
      'senderId': 'other',
      'text': 'That\'s great! Can we meet today?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
      'isSent': true,
      'isRead': true,
    },
    {
      'id': '4',
      'senderId': 'me',
      'text': 'Sure! How about 3 PM at the student center?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
      'isSent': true,
      'isRead': true,
    },
    {
      'id': '5',
      'senderId': 'other',
      'text': 'Perfect! See you there. Thanks so much!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isSent': true,
      'isRead': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Scroll to bottom after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    // TODO: Implement actual message sending to backend
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'senderId': 'me',
          'text': text,
          'timestamp': DateTime.now(),
          'isSent': true,
          'isRead': false,
        });
        _messageController.clear();
        _isSending = false;
      });

      // Scroll to bottom after adding message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
      final period = timestamp.hour >= 12 ? 'PM' : 'AM';
      return '$hour:${timestamp.minute.toString().padLeft(2, '0')} $period';
    } else if (difference.inDays < 7) {
      final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
      final period = timestamp.hour >= 12 ? 'PM' : 'AM';
      return '${days[timestamp.weekday % 7]} $hour:${timestamp.minute.toString().padLeft(2, '0')} $period';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
      final period = timestamp.hour >= 12 ? 'PM' : 'AM';
      return '${months[timestamp.month - 1]} ${timestamp.day}, $hour:${timestamp.minute.toString().padLeft(2, '0')} $period';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left_2_outline),
        ),
        title: Row(
          children: [
            UserAvatar(
              imageUrl: widget.recipientAvatarUrl,
              name: widget.recipientName,
              size: AppDimensions.avatarSmall,
            ),
            AppDimensions.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipientName,
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFontSize,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Active now',
                    style: TextStyle(
                      fontSize: AppDimensions.captionFontSize,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement chat options (block, report, etc.)
            },
            icon: Icon(
              Iconsax.more_outline,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.message_outline,
                          size: AppDimensions.largeIconSize * 2,
                          color: colorScheme.onSurface.withAlpha(77),
                        ),
                        AppDimensions.h16,
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: AppDimensions.subtitleFontSize,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        AppDimensions.h8,
                        Text(
                          'Start the conversation!',
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFontSize,
                            color: colorScheme.onSurface.withAlpha(102),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(AppDimensions.space16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe = message['senderId'] == 'me';
                      final showTimestamp = index == 0 ||
                          _messages[index - 1]['timestamp']
                                  .difference(message['timestamp'])
                                  .inMinutes
                                  .abs() >
                              5;

                      return Column(
                        children: [
                          if (showTimestamp)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimensions.space12,
                              ),
                              child: Text(
                                _formatTimestamp(message['timestamp']),
                                style: TextStyle(
                                  fontSize: AppDimensions.captionFontSize,
                                  color: colorScheme.onSurface.withAlpha(102),
                                ),
                              ),
                            ),
                          _MessageBubble(
                            text: message['text'],
                            isMe: isMe,
                            timestamp: message['timestamp'],
                            isSent: message['isSent'] ?? false,
                            isRead: message['isRead'] ?? false,
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // Message Input Area
          Container(
            padding: EdgeInsets.all(AppDimensions.space12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withAlpha(77),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppDimensions.radius12 * 2),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withAlpha(102),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.space16,
                            vertical: AppDimensions.space12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  AppDimensions.w8,
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? SizedBox(
                              height: AppDimensions.mediumIconSize * 0.7,
                              width: AppDimensions.mediumIconSize * 0.7,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Icon(
                              Iconsax.send_2_bold,
                              color: Colors.white,
                              size: AppDimensions.mediumIconSize,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool isSent;
  final bool isRead;

  const _MessageBubble({
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.isSent,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppDimensions.screenWidth * 0.75,
        ),
        margin: EdgeInsets.only(bottom: AppDimensions.space8),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radius16),
            topRight: Radius.circular(AppDimensions.radius16),
            bottomLeft: isMe
                ? Radius.circular(AppDimensions.radius16)
                : Radius.circular(AppDimensions.radius4),
            bottomRight: isMe
                ? Radius.circular(AppDimensions.radius4)
                : Radius.circular(AppDimensions.radius16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: AppDimensions.bodyFontSize,
                color: isMe ? Colors.white : colorScheme.onSurface,
              ),
            ),
            if (isMe) ...[
              AppDimensions.h4,
              Icon(
                isRead
                    ? Iconsax.tick_circle_bold
                    : isSent
                        ? Iconsax.tick_circle_outline
                        : Iconsax.clock_outline,
                size: AppDimensions.captionFontSize + 2,
                color: Colors.white.withAlpha(179),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
