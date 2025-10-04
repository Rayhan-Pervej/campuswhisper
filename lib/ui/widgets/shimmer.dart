
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'app_dimensions.dart';

/// Base shimmer wrapper with customizable colors
class ShimmerWrapper extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const ShimmerWrapper({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: child,
    );
  }
}

/// Shimmer box with rounded corners
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Shimmer circle for avatars
class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({
    super.key,
    this.size = 50,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Shimmer line for text
class ShimmerLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerLine({
    super.key,
    this.width,
    this.height = 12,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width,
      height: height,
      borderRadius: 4,
      margin: margin,
    );
  }
}

/// Course Roadmap Shimmer Loader
class CourseRoadmapShimmer extends StatelessWidget {
  final int itemCount;

  const CourseRoadmapShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Column(
        children: [
          // Department selector shimmer
          Container(
            padding: EdgeInsets.all(AppDimensions.space16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                ShimmerBox(
                  height: 56,
                  width: double.infinity,
                  borderRadius: AppDimensions.radius8,
                ),
                SizedBox(height: AppDimensions.space12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (index) => ShimmerBox(
                      width: 100,
                      height: 80,
                      borderRadius: AppDimensions.radius12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Semester cards shimmer
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.space16),
              itemCount: itemCount,
              itemBuilder: (context, index) => _buildSemesterCardShimmer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterCardShimmer() {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Semester header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.space16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radius12),
                topRight: Radius.circular(AppDimensions.radius12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerLine(width: 120, height: 16),
                ShimmerBox(width: 80, height: 24, borderRadius: 8),
              ],
            ),
          ),

          // Course items
          Padding(
            padding: EdgeInsets.all(AppDimensions.space12),
            child: Column(
              children: List.generate(
                4,
                (index) => _buildCourseItemShimmer(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItemShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.space8),
      padding: EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          ShimmerBox(width: 4, height: 50, borderRadius: 2),
          SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(width: 80, height: 12),
                SizedBox(height: AppDimensions.space4),
                ShimmerLine(width: double.infinity, height: 14),
                SizedBox(height: AppDimensions.space4),
                ShimmerLine(width: 150, height: 10),
              ],
            ),
          ),
          ShimmerBox(width: 50, height: 24, borderRadius: 8),
        ],
      ),
    );
  }
}

/// List Shimmer Loader (for generic lists)
class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;

  const ListShimmer({
    super.key,
    this.itemCount = 10,
    this.itemHeight = 80,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: ListView.builder(
        padding: padding ?? EdgeInsets.all(AppDimensions.space16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: AppDimensions.space12),
            child: Row(
              children: [
                ShimmerCircle(size: 50),
                SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLine(width: double.infinity, height: 16),
                      SizedBox(height: AppDimensions.space8),
                      ShimmerLine(width: 200, height: 12),
                      SizedBox(height: AppDimensions.space4),
                      ShimmerLine(width: 150, height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Grid Shimmer Loader
class GridShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;

  const GridShimmer({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: GridView.builder(
        padding: padding ?? EdgeInsets.all(AppDimensions.space16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppDimensions.space12,
          mainAxisSpacing: AppDimensions.space12,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: double.infinity,
                    height: 80,
                    borderRadius: AppDimensions.radius8,
                  ),
                  SizedBox(height: AppDimensions.space8),
                  ShimmerLine(width: double.infinity, height: 14),
                  SizedBox(height: AppDimensions.space4),
                  ShimmerLine(width: 100, height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Card Shimmer Loader
class CardShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const CardShimmer({
    super.key,
    this.itemCount = 5,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: ListView.builder(
        padding: padding ?? EdgeInsets.all(AppDimensions.space16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: AppDimensions.space16),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerCircle(size: 40),
                      SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerLine(width: 150, height: 14),
                            SizedBox(height: AppDimensions.space4),
                            ShimmerLine(width: 100, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.space12),
                  ShimmerLine(width: double.infinity, height: 12),
                  SizedBox(height: AppDimensions.space8),
                  ShimmerLine(width: double.infinity, height: 12),
                  SizedBox(height: AppDimensions.space8),
                  ShimmerLine(width: 200, height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Profile Shimmer Loader
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            // Avatar
            ShimmerCircle(size: 100),
            SizedBox(height: AppDimensions.space16),

            // Name
            ShimmerLine(width: 200, height: 20),
            SizedBox(height: AppDimensions.space8),

            // Email
            ShimmerLine(width: 250, height: 14),
            SizedBox(height: AppDimensions.space24),

            // Info cards
            ...List.generate(
              4,
              (index) => Card(
                margin: EdgeInsets.only(bottom: AppDimensions.space12),
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.space16),
                  child: Row(
                    children: [
                      ShimmerBox(width: 40, height: 40, borderRadius: 8),
                      SizedBox(width: AppDimensions.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerLine(width: 100, height: 12),
                            SizedBox(height: AppDimensions.space8),
                            ShimmerLine(width: double.infinity, height: 14),
                          ],
                        ),
                      ),
                    ],
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

/// Custom Shimmer Builder for completely custom layouts
class CustomShimmer extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const CustomShimmer({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: builder(context),
    );
  }
}