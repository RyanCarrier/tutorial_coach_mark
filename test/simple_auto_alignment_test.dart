import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_coach_mark/src/target/target_position.dart';
import 'package:tutorial_coach_mark/src/target/target_content.dart';

ContentAlign getAutoAlignment(TargetPosition target, Size screenSize) {
  final targetTop = target.offset.dy;
  final targetBottom = target.offset.dy + target.size.height;
  final targetLeft = target.offset.dx;
  final targetRight = target.offset.dx + target.size.width;

  // Calculate available space on each side, clamping negatives to zero
  final spaceTop = targetTop.clamp(0, double.infinity);
  final spaceBottom = (screenSize.height - targetBottom).clamp(0, double.infinity);
  final spaceLeft = targetLeft.clamp(0, double.infinity);
  final spaceRight = (screenSize.width - targetRight).clamp(0, double.infinity);

  // Find the side with the most space
  final maxSpace = [spaceTop, spaceBottom, spaceLeft, spaceRight]
      .reduce((a, b) => a > b ? a : b);

  if (maxSpace == spaceTop) {
    return ContentAlign.top;
  } else if (maxSpace == spaceBottom) {
    return ContentAlign.bottom;
  } else if (maxSpace == spaceLeft) {
    return ContentAlign.left;
  } else {
    return ContentAlign.right;
  }
}

void main() {
  group('Auto Alignment Logic Tests', () {
    test('Auto alignment selects bottom when target is at top', () {
      // Create a target at the top of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(100, 50));
      final screenSize = const Size(300, 600);
      
      final result = getAutoAlignment(target, screenSize);
      
      // Since target is near the top, should choose bottom
      expect(result, ContentAlign.bottom);
    });

    test('Auto alignment selects top when target is at bottom', () {
      // Create a target at the bottom of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(100, 550));
      final screenSize = const Size(300, 600);
      
      final result = getAutoAlignment(target, screenSize);
      
      // Since target is near the bottom, should choose top
      expect(result, ContentAlign.top);
    });

    test('Auto alignment selects right when target is at left', () {
      // Create a target at the left of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(25, 300));
      final screenSize = const Size(600, 400);
      
      final result = getAutoAlignment(target, screenSize);
      
      // Since target is near the left, should choose right
      expect(result, ContentAlign.right);
    });

    test('Auto alignment selects left when target is at right', () {
      // Create a target at the right of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(550, 300));
      final screenSize = const Size(600, 400);
      
      final result = getAutoAlignment(target, screenSize);
      
      // Since target is near the right, should choose left
      expect(result, ContentAlign.left);
    });

    test('Auto alignment handles center target correctly', () {
      // Create a target at the center of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(275, 275));
      final screenSize = const Size(600, 600);
      
      final result = getAutoAlignment(target, screenSize);
      
      // For a centered target, all spaces should be roughly equal
      // The function should still return a valid alignment
      expect([ContentAlign.top, ContentAlign.bottom, ContentAlign.left, ContentAlign.right]
          .contains(result), isTrue);
    });
  });
}