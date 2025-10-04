// import 'package:flutter/material.dart';

// class AppDimensions {
//   // Padding and spacing
//   static const double space2 = 2.0;
//   static const double space4 = 4.0;
//   static const double space8 = 8.0;
//   static const double space12 = 12.0;
//   static const double space16 = 16.0;
//   static const double space24 = 24.0;
//   static const double space32 = 32.0;
//   static const double space40 = 40.0;

//   // size

//   static const double size16 = 16.0;
//   static const double size24 = 24.0;
//   static const double size32 = 32.0;
//   static const double size48 = 48.0;

//   // Radius
//   static const double radius4 = 4.0;
//   static const double radius8 = 8.0;
//   static const double radius12 = 12.0;
//   static const double radius16 = 16.0;

//   // Elevation
//   static const double elevation1 = 1.0;
//   static const double elevation2 = 2.0;
//   static const double elevation4 = 4.0;

//   // Screen default padding
//   static const double horizontalPadding = 20.0;
//   static const double verticalPadding = 16;

//   // Standard Heights
//   static const SizedBox h4 = SizedBox(height: space4);
//   static const SizedBox h8 = SizedBox(height: space8);
//   static const SizedBox h12 = SizedBox(height: space12);
//   static const SizedBox h16 = SizedBox(height: space16);
//   static const SizedBox h24 = SizedBox(height: space24);
//   static const SizedBox h32 = SizedBox(height: space32);

//   // Standard Widths
//   static const SizedBox w4 = SizedBox(width: space4);
//   static const SizedBox w8 = SizedBox(width: space8);
//   static const SizedBox w12 = SizedBox(width: space12);
//   static const SizedBox w16 = SizedBox(width: space16);
//   static const SizedBox w24 = SizedBox(width: space24);
//   static const SizedBox w32 = SizedBox(width: space32);

//   // Spacer
//   static const Spacer flexibleSpacer = Spacer();
// }

import 'package:flutter/material.dart';

class AppDimensions {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  // Device type detection
  static bool get isSmallScreen => screenWidth < 600;
  static bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  static bool get isLargeScreen => screenWidth >= 1200;

  // Initialize dimensions - call this in your app's build method
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
  }

  // Base spacing values that scale with screen size
  static double get space2 => screenWidth * 0.005; // ~2dp on 400px width
  static double get space4 => screenWidth * 0.01; // ~4dp on 400px width
  static double get space8 => screenWidth * 0.02; // ~8dp on 400px width
  static double get space12 => screenWidth * 0.03; // ~12dp on 400px width
  static double get space16 => screenWidth * 0.04; // ~16dp on 400px width
  static double get space24 => screenWidth * 0.06; // ~24dp on 400px width
  static double get space32 => screenWidth * 0.08; // ~32dp on 400px width
  static double get space40 => screenWidth * 0.1; // ~40dp on 400px width

  // Responsive sizes
  static double get size16 => isSmallScreen
      ? 16.0
      : isMediumScreen
      ? 18.0
      : 20.0;
  static double get size24 => isSmallScreen
      ? 24.0
      : isMediumScreen
      ? 28.0
      : 32.0;
  static double get size32 => isSmallScreen
      ? 32.0
      : isMediumScreen
      ? 38.0
      : 44.0;
  static double get size48 => isSmallScreen
      ? 48.0
      : isMediumScreen
      ? 56.0
      : 64.0;

  // Responsive radius
  static double get radius4 => isSmallScreen ? 4.0 : 6.0;
  static double get radius8 => isSmallScreen ? 8.0 : 10.0;
  static double get radius12 => isSmallScreen ? 12.0 : 14.0;
  static double get radius16 => isSmallScreen ? 16.0 : 18.0;

  // Responsive elevation
  static double get elevation1 => 1.0;
  static double get elevation2 => 2.0;
  static double get elevation4 => 4.0;

  // Responsive padding
  static double get horizontalPadding =>
      screenWidth * 0.05; // 5% of screen width
  static double get verticalPadding =>
      screenHeight * 0.02; // 2% of screen height

  // Responsive Heights
  static SizedBox get h4 => SizedBox(height: space4);
  static SizedBox get h8 => SizedBox(height: space8);
  static SizedBox get h12 => SizedBox(height: space12);
  static SizedBox get h16 => SizedBox(height: space16);
  static SizedBox get h24 => SizedBox(height: space24);
  static SizedBox get h32 => SizedBox(height: space32);

  // Responsive Widths
  static SizedBox get w4 => SizedBox(width: space4);
  static SizedBox get w8 => SizedBox(width: space8);
  static SizedBox get w12 => SizedBox(width: space12);
  static SizedBox get w16 => SizedBox(width: space16);
  static SizedBox get w24 => SizedBox(width: space24);
  static SizedBox get w32 => SizedBox(width: space32);

  // Percentage-based helpers
  static double widthPercentage(double percentage) =>
      screenWidth * (percentage / 100);
  static double heightPercentage(double percentage) =>
      screenHeight * (percentage / 100);

  // Safe area percentage helpers
  static double safeWidthPercentage(double percentage) =>
      (screenWidth - safeAreaHorizontal) * (percentage / 100);
  static double safeHeightPercentage(double percentage) =>
      (screenHeight - safeAreaVertical) * (percentage / 100);

  // Fixed spacer
  static const Spacer flexibleSpacer = Spacer();

  // Responsive font sizes
  static double get titleFontSize => isSmallScreen
      ? 20.0
      : isMediumScreen
      ? 24.0
      : 28.0;
  static double get subtitleFontSize => isSmallScreen
      ? 16.0
      : isMediumScreen
      ? 18.0
      : 20.0;
  static double get bodyFontSize => isSmallScreen
      ? 14.0
      : isMediumScreen
      ? 16.0
      : 18.0;
  static double get captionFontSize => isSmallScreen
      ? 12.0
      : isMediumScreen
      ? 14.0
      : 16.0;

  // Responsive icon sizes
  static double get smallIconSize => isSmallScreen
      ? 18.0
      : isMediumScreen
      ? 20.0
      : 22.0;
  static double get mediumIconSize => isSmallScreen
      ? 24.0
      : isMediumScreen
      ? 28.0
      : 32.0;
  static double get largeIconSize => isSmallScreen
      ? 32.0
      : isMediumScreen
      ? 36.0
      : 40.0;

  // Button heights
  static double get buttonHeight => isSmallScreen
      ? 44.0
      : isMediumScreen
      ? 48.0
      : 52.0;
  static double get smallButtonHeight => isSmallScreen
      ? 32.0
      : isMediumScreen
      ? 36.0
      : 40.0;

  // Container constraints
  static double get maxContentWidth => isLargeScreen ? 1200.0 : double.infinity;

  // Container sizes - Small
  static double get containerXS => widthPercentage(20); // 20% width
  static double get containerSM => widthPercentage(30); // 30% width
  static double get containerMD => widthPercentage(50); // 50% width
  static double get containerLG => widthPercentage(70); // 70% width
  static double get containerXL => widthPercentage(90); // 90% width
  static double get containerFull => widthPercentage(100); // 100% width

  // Fixed container sizes (responsive to screen size)
  static double get containerSmall => isSmallScreen
      ? 280.0
      : isMediumScreen
      ? 320.0
      : 360.0;
  static double get containerMedium => isSmallScreen
      ? 350.0
      : isMediumScreen
      ? 400.0
      : 450.0;
  static double get containerLarge => isSmallScreen
      ? 450.0
      : isMediumScreen
      ? 500.0
      : 550.0;

  // Container heights
  static double get containerHeightXS => heightPercentage(10); // 10% height
  static double get containerHeightSM => heightPercentage(20); // 20% height
  static double get containerHeightMD => heightPercentage(30); // 30% height
  static double get containerHeightLG => heightPercentage(50); // 50% height
  static double get containerHeightXL => heightPercentage(70); // 70% height

  // Fixed container heights (responsive)
  static double get containerHeightSmall => isSmallScreen
      ? 100.0
      : isMediumScreen
      ? 120.0
      : 140.0;
  static double get containerHeightMedium => isSmallScreen
      ? 200.0
      : isMediumScreen
      ? 240.0
      : 280.0;
  static double get containerHeightLarge => isSmallScreen
      ? 300.0
      : isMediumScreen
      ? 350.0
      : 400.0;

  // Card and dialog sizes
  static double get cardWidth =>
      isSmallScreen ? containerMedium : containerLarge;
  static double get cardHeight => isSmallScreen
      ? 180.0
      : isMediumScreen
      ? 200.0
      : 220.0;
  static double get dialogWidth =>
      isSmallScreen ? widthPercentage(90) : widthPercentage(60);
  static double get dialogMaxWidth => isSmallScreen ? 400.0 : 600.0;

  // Avatar and profile image sizes
  static double get avatarSmall => isSmallScreen ? 32.0 : 36.0;
  static double get avatarMedium => isSmallScreen
      ? 48.0
      : isMediumScreen
      ? 56.0
      : 64.0;
  static double get avatarLarge => isSmallScreen
      ? 80.0
      : isMediumScreen
      ? 96.0
      : 112.0;
  static double get avatarXL => isSmallScreen
      ? 120.0
      : isMediumScreen
      ? 140.0
      : 160.0;

  // List item heights
  static double get listItemSmall => isSmallScreen ? 48.0 : 56.0;
  static double get listItemMedium => isSmallScreen ? 64.0 : 72.0;
  static double get listItemLarge => isSmallScreen ? 80.0 : 88.0;

  // Image container sizes
  static double get imageContainerSmall => isSmallScreen
      ? 100.0
      : isMediumScreen
      ? 120.0
      : 140.0;
  static double get imageContainerMedium => isSmallScreen
      ? 200.0
      : isMediumScreen
      ? 240.0
      : 280.0;
  static double get imageContainerLarge => isSmallScreen
      ? 300.0
      : isMediumScreen
      ? 350.0
      : 400.0;

  // Banner and header heights
  static double get bannerHeight => isSmallScreen
      ? 120.0
      : isMediumScreen
      ? 150.0
      : 180.0;
  static double get headerHeight => isSmallScreen
      ? 200.0
      : isMediumScreen
      ? 250.0
      : 300.0;

  // Bottom sheet heights
  static double get bottomSheetMinHeight => heightPercentage(30);
  static double get bottomSheetMaxHeight => heightPercentage(90);

  // Responsive squares (equal width and height)
  static double get squareSmall => isSmallScreen
      ? 60.0
      : isMediumScreen
      ? 70.0
      : 80.0;
  static double get squareMedium => isSmallScreen
      ? 100.0
      : isMediumScreen
      ? 120.0
      : 140.0;
  static double get squareLarge => isSmallScreen
      ? 150.0
      : isMediumScreen
      ? 180.0
      : 210.0;
}
