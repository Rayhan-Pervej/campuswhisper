import 'package:flutter/material.dart';

enum TransitionType {
  slideBottomToTop,
  slideTopToBottom,
  slideLeftToRight,
  slideRightToLeft,
  fadeIn,
  scaleFromCenter,
  scaleFromPosition,
  rotateIn,
  slideAndFade,
  elasticIn,
}

class CustomPageTransitions {
  
  // Main function to create route with custom transition
  static Route<T> createRoute<T extends Object?>({
    required Widget page,
    required TransitionType transitionType,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset? clickPosition, // For click position animation
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          transitionType: transitionType,
          curve: curve,
          clickPosition: clickPosition,
          context: context,
        );
      },
    );
  }

  // Build the actual transition
  static Widget _buildTransition({
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
    required TransitionType transitionType,
    required Curve curve,
    Offset? clickPosition,
    BuildContext? context,
  }) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (transitionType) {
      case TransitionType.slideBottomToTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.slideTopToBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.slideLeftToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.slideRightToLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.fadeIn:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case TransitionType.scaleFromCenter:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.scaleFromPosition:
        final position = clickPosition ?? const Offset(0.5, 0.5);
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          alignment: Alignment(
            (position.dx * 2) - 1, // Convert 0-1 to -1 to 1
            (position.dy * 2) - 1,
          ),
          child: child,
        );

      case TransitionType.rotateIn:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );

      case TransitionType.slideAndFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case TransitionType.elasticIn:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: child,
        );
    }
  }
}