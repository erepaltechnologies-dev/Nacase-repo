import 'package:flutter/material.dart';

/// A reusable wrapper widget that adds swipe-to-go-back functionality
/// to any screen in the app. Simply wrap your screen content with this widget.
class SwipeToGoBack extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final double velocityThreshold;
  final VoidCallback? onSwipeBack;

  const SwipeToGoBack({
    Key? key,
    required this.child,
    this.enabled = true,
    this.velocityThreshold = 300.0,
    this.onSwipeBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return GestureDetector(
      onPanUpdate: (details) {
        // Track horizontal swipe direction (left to right)
        if (details.delta.dx > 0) {
          // User is swiping from left to right
        }
      },
      onPanEnd: (details) {
        // Check if the swipe velocity is sufficient for navigation
        if (details.velocity.pixelsPerSecond.dx > velocityThreshold) {
          // Execute custom callback if provided, otherwise use default navigation
          if (onSwipeBack != null) {
            onSwipeBack!();
          } else {
            // Default behavior: navigate back if possible
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: child,
    );
  }
}

/// Extension method to easily add swipe-to-go-back to any widget
extension SwipeToGoBackExtension on Widget {
  /// Wraps the widget with SwipeToGoBack functionality
  Widget withSwipeToGoBack({
    bool enabled = true,
    double velocityThreshold = 300.0,
    VoidCallback? onSwipeBack,
  }) {
    return SwipeToGoBack(
      enabled: enabled,
      velocityThreshold: velocityThreshold,
      onSwipeBack: onSwipeBack,
      child: this,
    );
  }
}