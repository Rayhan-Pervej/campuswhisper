import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';

class ContactPosterPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const ContactPosterPage({
    super.key,
    required this.item,
  });

  @override
  State<ContactPosterPage> createState() => _ContactPosterPageState();
}

class _ContactPosterPageState extends State<ContactPosterPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Contact Poster',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDimensions.h16,

            // Poster Info Card
            Container(
              padding: EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
              ),
              child: Row(
                children: [
                  UserAvatar(
                    imageUrl: widget.item['posterAvatar'],
                    name: widget.item['posterName'] ?? 'Unknown',
                    size: 50,
                  ),
                  AppDimensions.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildText(
                          text: widget.item['posterName'] ?? 'Unknown User',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        AppDimensions.h4,
                        BuildText(
                          text: 'Item: ${widget.item['itemName'] ?? 'Unknown'}',
                          fontSize: 13,
                          color: colorScheme.onSurface.withAlpha(153),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.h24,

            // Info message
            Container(
              padding: EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(51),
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                border: Border.all(
                  color: colorScheme.primary.withAlpha(77),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.info_circle_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  AppDimensions.w12,
                  Expanded(
                    child: BuildText(
                      text:
                          'Please provide your contact information so the poster can reach you.',
                      fontSize: 13,
                      color: colorScheme.primary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.h24,

            // Contact Information
            BuildText(
              text: 'Your Contact Information',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            AppDimensions.h8,
            BuildText(
              text: 'Email or Phone Number',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(153),
            ),
            AppDimensions.h12,
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                hintText: 'e.g., john@example.com or +1234567890',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withAlpha(102),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space16,
                ),
                prefixIcon: Icon(
                  Iconsax.sms_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            AppDimensions.h24,

            // Message
            BuildText(
              text: 'Message',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            AppDimensions.h8,
            BuildText(
              text: 'Describe why you\'re contacting them',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(153),
            ),
            AppDimensions.h12,
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'I believe this is my item because...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withAlpha(102),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(AppDimensions.space16),
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            AppDimensions.h32,

            // Send Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.space16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.send_2_outline, size: 18),
                          AppDimensions.w8,
                          const Text(
                            'Send Message',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            AppDimensions.h24,

            // Privacy note
            Container(
              padding: EdgeInsets.all(AppDimensions.space12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.shield_tick_outline,
                    size: 16,
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                  AppDimensions.w8,
                  Expanded(
                    child: BuildText(
                      text:
                          'Your contact information will only be shared with the poster',
                      fontSize: 11,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_contactController.text.trim().isEmpty) {
      SnackbarHelper.showWarning(
        context,
        'Please enter your contact information',
      );
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      SnackbarHelper.showWarning(
        context,
        'Please enter a message',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    SnackbarHelper.showSuccess(
      context,
      'Message sent successfully!',
    );

    // Wait a bit then pop
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.pop(context);
  }
}
