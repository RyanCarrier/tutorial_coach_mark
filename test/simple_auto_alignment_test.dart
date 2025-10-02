import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_coach_mark/src/target/target_position.dart';
import 'package:tutorial_coach_mark/src/target/target_content.dart';

ContentAlign getAutoAlignment(
  TargetPosition target,
  Size screenSize, {
  AutoAlignmentMinSpace? minSpace,
}) {
  final targetTop = target.offset.dy;
  final targetBottom = target.offset.dy + target.size.height;
  final targetLeft = target.offset.dx;
  final targetRight = target.offset.dx + target.size.width;

  // Calculate available space on each side, clamping negatives to zero
  final spaceTop = targetTop.clamp(0, double.infinity).toDouble();
  final spaceBottom =
      (screenSize.height - targetBottom).clamp(0, double.infinity).toDouble();
  final spaceLeft = targetLeft.clamp(0, double.infinity).toDouble();
  final spaceRight =
      (screenSize.width - targetRight).clamp(0, double.infinity).toDouble();

  // Build list of valid sides that meet minimum space requirements
  List<MapEntry<ContentAlign, double>> validSides = [];

  if (minSpace == null) {
    // No minimum requirements, all sides are valid
    validSides = [
      MapEntry(ContentAlign.top, spaceTop),
      MapEntry(ContentAlign.bottom, spaceBottom),
      MapEntry(ContentAlign.left, spaceLeft),
      MapEntry(ContentAlign.right, spaceRight),
    ];
  } else {
    // Check each side against minimum requirements
    final minVertical = minSpace.vertical;
    final minHorizontal = minSpace.horizontal;

    if (minVertical == null || spaceTop >= minVertical) {
      validSides.add(MapEntry(ContentAlign.top, spaceTop));
    }
    if (minVertical == null || spaceBottom >= minVertical) {
      validSides.add(MapEntry(ContentAlign.bottom, spaceBottom));
    }
    if (minHorizontal == null || spaceLeft >= minHorizontal) {
      validSides.add(MapEntry(ContentAlign.left, spaceLeft));
    }
    if (minHorizontal == null || spaceRight >= minHorizontal) {
      validSides.add(MapEntry(ContentAlign.right, spaceRight));
    }
  }

  // If no sides meet the requirements, center the content
  if (validSides.isEmpty) {
    return ContentAlign.center;
  }

  // Find the side with the most space among valid sides
  final bestSide = validSides.reduce((a, b) => a.value > b.value ? a : b);
  return bestSide.key;
}

void main() {
  group('Auto Alignment Logic Tests', () {
    test('Auto alignment selects bottom when target is at top', () {
      // Create a target at the top of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(100, 50));
      const screenSize = Size(300, 600);

      final result = getAutoAlignment(target, screenSize);

      // Since target is near the top, should choose bottom
      expect(result, ContentAlign.bottom);
    });

    test('Auto alignment selects top when target is at bottom', () {
      // Create a target at the bottom of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(100, 550));
      const screenSize = Size(300, 600);

      final result = getAutoAlignment(target, screenSize);

      // Since target is near the bottom, should choose top
      expect(result, ContentAlign.top);
    });

    test('Auto alignment selects right when target is at left', () {
      // Create a target at the left of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(25, 300));
      const screenSize = Size(600, 400);

      final result = getAutoAlignment(target, screenSize);

      // Since target is near the left, should choose right
      expect(result, ContentAlign.right);
    });

    test('Auto alignment selects left when target is at right', () {
      // Create a target at the right of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(550, 300));
      const screenSize = Size(600, 400);

      final result = getAutoAlignment(target, screenSize);

      // Since target is near the right, should choose left
      expect(result, ContentAlign.left);
    });

    test('Auto alignment handles center target correctly', () {
      // Create a target at the center of the screen
      final target = TargetPosition(const Size(50, 50), const Offset(275, 275));
      const screenSize = Size(600, 600);

      final result = getAutoAlignment(target, screenSize);

      // For a centered target, all spaces should be roughly equal
      // The function should still return a valid alignment
      expect(
          [
            ContentAlign.top,
            ContentAlign.bottom,
            ContentAlign.left,
            ContentAlign.right
          ].contains(result),
          isTrue);
    });

    test('Auto alignment respects vertical minimum space', () {
      // Target at top with 50px above
      final target = TargetPosition(const Size(50, 50), const Offset(300, 50));
      const screenSize = Size(600, 600);

      // Require 100px vertical minimum - top has only 50px, so should go bottom
      final result = getAutoAlignment(
        target,
        screenSize,
        minSpace: const AutoAlignmentMinSpace(vertical: 100.0),
      );

      expect(result, ContentAlign.bottom);
    });

    test('Auto alignment respects horizontal minimum space', () {
      // Target at left with 25px to the left
      final target = TargetPosition(const Size(50, 50), const Offset(25, 300));
      const screenSize = Size(600, 400);

      // Require 100px horizontal minimum - left has only 25px, so should go right
      final result = getAutoAlignment(
        target,
        screenSize,
        minSpace: const AutoAlignmentMinSpace(horizontal: 100.0),
      );

      expect(result, ContentAlign.right);
    });

    test('Auto alignment centers when no side meets requirements', () {
      // Target in center
      final target = TargetPosition(const Size(50, 50), const Offset(275, 275));
      const screenSize = Size(600, 600);

      // Require impossibly large space - should center
      final result = getAutoAlignment(
        target,
        screenSize,
        minSpace: const AutoAlignmentMinSpace(
          horizontal: 1000.0,
          vertical: 1000.0,
        ),
      );

      expect(result, ContentAlign.center);
    });

    test('Auto alignment with only vertical minimum allows horizontal sides',
        () {
      // Target at top
      final target = TargetPosition(const Size(50, 50), const Offset(100, 50));
      const screenSize = Size(600, 600);

      // Only vertical minimum set - horizontal sides (left/right) should be allowed
      final result = getAutoAlignment(
        target,
        screenSize,
        minSpace: const AutoAlignmentMinSpace(vertical: 100.0),
      );

      // Should choose bottom (most space vertically that meets requirement)
      // or potentially left/right if horizontal space is greater
      expect(
          [ContentAlign.bottom, ContentAlign.left, ContentAlign.right]
              .contains(result),
          isTrue);
    });

    test('Auto alignment with only horizontal minimum allows vertical sides',
        () {
      // Target at left
      final target = TargetPosition(const Size(50, 50), const Offset(25, 300));
      const screenSize = Size(600, 600);

      // Only horizontal minimum set - vertical sides (top/bottom) should be allowed
      final result = getAutoAlignment(
        target,
        screenSize,
        minSpace: const AutoAlignmentMinSpace(horizontal: 100.0),
      );

      // Should choose right (most space horizontally that meets requirement)
      // or potentially top/bottom if vertical space is greater
      expect(
          [ContentAlign.right, ContentAlign.top, ContentAlign.bottom]
              .contains(result),
          isTrue);
    });
  });
}

