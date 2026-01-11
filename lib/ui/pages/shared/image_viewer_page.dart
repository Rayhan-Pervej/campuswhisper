import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/cached_image.dart';
import 'package:icons_plus/icons_plus.dart';

class ImageViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTag;

  const ImageViewerPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Image PageView
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final imageUrl = widget.imageUrls[index];

                Widget imageWidget = InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: CachedImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      errorWidget: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: AppDimensions.largeIconSize * 2,
                              color: Colors.white.withAlpha(153),
                            ),
                            AppDimensions.h16,
                            Text(
                              'Failed to load image',
                              style: TextStyle(
                                color: Colors.white.withAlpha(153),
                                fontSize: AppDimensions.bodyFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

                // Wrap with Hero animation if heroTag is provided and it's the initial image
                if (widget.heroTag != null && index == widget.initialIndex) {
                  imageWidget = Hero(
                    tag: widget.heroTag!,
                    child: imageWidget,
                  );
                }

                return imageWidget;
              },
            ),

            // Top Controls
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _showControls ? 0 : -100,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(179),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    child: Row(
                      children: [
                        // Back Button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Iconsax.arrow_left_2_outline,
                            color: Colors.white,
                            size: AppDimensions.mediumIconSize,
                          ),
                        ),

                        Spacer(),

                        // Image Counter
                        if (widget.imageUrls.length > 1)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.space12,
                              vertical: AppDimensions.space8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(128),
                              borderRadius: BorderRadius.circular(AppDimensions.radius12),
                            ),
                            child: Text(
                              '${_currentIndex + 1} / ${widget.imageUrls.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppDimensions.bodyFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        Spacer(),

                        // Share Button
                        IconButton(
                          onPressed: () {
                            // TODO: Implement share functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Share functionality coming soon'),
                                backgroundColor: Colors.white.withAlpha(51),
                              ),
                            );
                          },
                          icon: Icon(
                            Iconsax.share_outline,
                            color: Colors.white,
                            size: AppDimensions.mediumIconSize,
                          ),
                        ),

                        // Download Button
                        IconButton(
                          onPressed: () {
                            // TODO: Implement download functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Download functionality coming soon'),
                                backgroundColor: Colors.white.withAlpha(51),
                              ),
                            );
                          },
                          icon: Icon(
                            Iconsax.document_download_outline,
                            color: Colors.white,
                            size: AppDimensions.mediumIconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Dots (for multiple images)
            if (widget.imageUrls.length > 1)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                bottom: _showControls ? 0 : -100,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withAlpha(179),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.space24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.imageUrls.length > 10 ? 10 : widget.imageUrls.length,
                          (index) {
                            if (widget.imageUrls.length > 10 && index == 9) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppDimensions.space4),
                                child: Text(
                                  '+${widget.imageUrls.length - 9}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppDimensions.captionFontSize,
                                  ),
                                ),
                              );
                            }

                            final isActive = _currentIndex == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.symmetric(horizontal: AppDimensions.space4),
                              height: AppDimensions.space8,
                              width: isActive ? AppDimensions.space24 : AppDimensions.space8,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.white : Colors.white.withAlpha(128),
                                borderRadius: BorderRadius.circular(AppDimensions.space4),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
