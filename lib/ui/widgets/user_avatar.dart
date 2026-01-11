import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/constants/app_constants.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double? size;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarSize = size ?? AppDimensions.largeIconSize;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withAlpha(51),
          border: Border.all(
            color: colorScheme.primary.withAlpha(77),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFallback(context, colorScheme, avatarSize);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                    );
                  },
                )
              : _buildFallback(context, colorScheme, avatarSize),
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context, ColorScheme colorScheme, double size) {
    if (name != null && name!.isNotEmpty) {
      final initials = _getInitials(name!);
      return Container(
        color: colorScheme.primary,
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Icon(
      Icons.person,
      size: size * 0.6,
      color: colorScheme.primary,
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
