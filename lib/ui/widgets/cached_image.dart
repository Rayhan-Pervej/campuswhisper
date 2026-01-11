import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? _buildPlaceholder(colorScheme),
      errorWidget: (context, url, error) => errorWidget ?? _buildError(colorScheme),
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: colorScheme.surface,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildError(ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: colorScheme.surface,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: AppDimensions.largeIconSize,
          color: colorScheme.onSurface.withAlpha(77),
        ),
      ),
    );
  }
}
