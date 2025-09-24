import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/src/target/target_content.dart';
import 'package:tutorial_coach_mark/src/target/target_focus.dart';
import 'package:tutorial_coach_mark/src/target/target_position.dart';
import 'package:tutorial_coach_mark/src/util.dart';
import 'package:tutorial_coach_mark/src/widgets/animated_focus_light.dart';

class TutorialCoachMarkWidget extends StatefulWidget {
  const TutorialCoachMarkWidget({
    Key? key,
    this.targets,
    this.targetsBuilder,
    this.targetCount,
    this.finish,
    this.paddingFocus = 10,
    this.clickTarget,
    this.onClickTargetWithTapPosition,
    this.clickOverlay,
    this.alignSkip = Alignment.bottomRight,
    this.textSkip = "SKIP",
    this.onClickSkip,
    this.skipWidget,
    this.colorShadow = Colors.black,
    this.opacityShadow = 0.8,
    this.textStyleSkip = const TextStyle(color: Colors.white),
    this.hideSkip = false,
    this.useSafeArea = true,
    this.focusAnimationDuration,
    this.unFocusAnimationDuration,
    this.pulseAnimationDuration,
    this.pulseVariation,
    this.pulseEnable = true,
    this.rootOverlay = false,
    this.showSkipInLastTarget = false,
    this.imageFilter,
    this.backgroundSemanticLabel,
    this.initialFocus = 0,
  })  : assert(targets != null || targetsBuilder != null),
        assert(targetCount == null || targetCount > 0),
        super(key: key);

  final List<TargetFocus>? targets;
  final TargetFocus? Function(int index, BuildContext context)? targetsBuilder;
  final int? targetCount;
  final FutureOr Function(TargetFocus)? clickTarget;
  final FutureOr Function(TargetFocus, TapDownDetails)?
      onClickTargetWithTapPosition;
  final FutureOr Function(TargetFocus)? clickOverlay;
  final void Function()? finish;
  final Color colorShadow;
  final double opacityShadow;
  final double paddingFocus;
  final void Function()? onClickSkip;
  final AlignmentGeometry alignSkip;
  final String textSkip;
  final TextStyle textStyleSkip;
  final bool hideSkip;
  final bool useSafeArea;
  final Duration? focusAnimationDuration;
  final Duration? unFocusAnimationDuration;
  final Duration? pulseAnimationDuration;
  final Tween<double>? pulseVariation;
  final bool pulseEnable;
  final Widget? skipWidget;
  final bool rootOverlay;
  final bool showSkipInLastTarget;
  final ImageFilter? imageFilter;
  final int initialFocus;
  final String? backgroundSemanticLabel;

  @override
  TutorialCoachMarkWidgetState createState() => TutorialCoachMarkWidgetState();
}

class TutorialCoachMarkWidgetState extends State<TutorialCoachMarkWidget>
    with WidgetsBindingObserver
    implements TutorialCoachMarkController {
  final GlobalKey<AnimatedFocusLightState> _focusLightKey = GlobalKey();
  bool showContent = false;
  TargetFocus? currentTarget;
  int currentFocusIndex = 0;

  @override
  void initState() {
    super.initState();

    // Runtime validation
    if (widget.targets == null && widget.targetsBuilder == null) {
      throw ArgumentError('Either targets or targetsBuilder must be provided');
    }
    if (widget.targets != null && widget.targetsBuilder != null) {
      throw ArgumentError(
          'Cannot provide both targets and targetsBuilder. Choose one approach.');
    }
    if (widget.targetsBuilder != null && widget.targetCount == null) {
      throw ArgumentError(
          'targetCount must be provided when using targetsBuilder');
    }
    if (widget.targets != null && widget.targets!.isEmpty) {
      throw ArgumentError('targets list cannot be empty');
    }
    if (widget.targetCount != null && widget.targetCount! <= 0) {
      throw ArgumentError('targetCount must be greater than 0');
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called when screen metrics change (orientation, size, etc.)
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    refresh();
  }

  @override
  void refresh() {
    // Refresh the focus area position for the currently focused target
    _focusLightKey.currentState?.refreshTargetPosition();
    // Trigger a rebuild to recalculate content positions
    safeSetState(() {});
  }

  /// Gets the total number of targets in the tutorial sequence.
  int get totalTargets => widget.targets?.length ?? widget.targetCount ?? 0;

  /// Gets a target at the specified index using either the static list or the builder function.
  /// Returns null if the index is out of range or if the builder returns null.
  TargetFocus? getTargetAt(int index) {
    if (widget.targets != null) {
      if (index >= 0 && index < widget.targets!.length) {
        return widget.targets![index];
      }
      return null;
    }

    if (widget.targetsBuilder != null && widget.targetCount != null) {
      if (index >= 0 && index < widget.targetCount!) {
        return widget.targetsBuilder!(index, context);
      }
      return null;
    }

    return null;
  }

  /// Gets all targets as a list. This method builds targets on-demand when using a builder.
  List<TargetFocus> get allTargets {
    if (widget.targets != null) {
      return widget.targets!;
    }

    if (widget.targetsBuilder != null && widget.targetCount != null) {
      List<TargetFocus> targets = [];
      for (int i = 0; i < widget.targetCount!; i++) {
        final target = widget.targetsBuilder!(i, context);
        if (target != null) {
          targets.add(target);
        }
      }
      return targets;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          AnimatedFocusLight(
            key: _focusLightKey,
            initialFocus: widget.initialFocus,
            targets: widget.targets,
            targetsBuilder: widget.targetsBuilder,
            targetCount: widget.targetCount,
            finish: widget.finish,
            paddingFocus: widget.paddingFocus,
            colorShadow: widget.colorShadow,
            opacityShadow: widget.opacityShadow,
            focusAnimationDuration: widget.focusAnimationDuration,
            unFocusAnimationDuration: widget.unFocusAnimationDuration,
            pulseAnimationDuration: widget.pulseAnimationDuration,
            pulseVariation: widget.pulseVariation,
            pulseEnable: widget.pulseEnable,
            rootOverlay: widget.rootOverlay,
            imageFilter: widget.imageFilter,
            backgroundSemanticLabel: widget.backgroundSemanticLabel,
            clickTarget: (target) {
              return widget.clickTarget?.call(target);
            },
            clickTargetWithTapPosition: (target, tapDetails) {
              return widget.onClickTargetWithTapPosition
                  ?.call(target, tapDetails);
            },
            clickOverlay: (target) {
              return widget.clickOverlay?.call(target);
            },
            focus: (target) {
              setState(() {
                currentTarget = target;
                showContent = true;
              });
            },
            onNewFocus: (focusIndex) {
              setState(() {
                currentFocusIndex = focusIndex;
              });
            },
            removeFocus: () {
              setState(() {
                showContent = false;
              });
            },
          ),
          AnimatedOpacity(
            opacity: showContent ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: _buildContents(),
          ),
          _buildSkip()
        ],
      ),
    );
  }

  /// Determines the best alignment for auto positioning based on available space.
  @visibleForTesting
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

  Widget _buildContents() {
    if (currentTarget == null) {
      return const SizedBox.shrink();
    }
    List<Widget> children = <Widget>[];
    TargetPosition? target;
    try {
      target = getTargetCurrent(
        currentTarget!,
        rootOverlay: widget.rootOverlay,
      );
    } on NotFoundTargetException catch (_) {
      try {
        var freshTarget = getTargetAt(currentFocusIndex);
        if (freshTarget == null) {
          rethrow;
        }
        target = getTargetCurrent(
          freshTarget,
          rootOverlay: widget.rootOverlay,
        );
        currentTarget = freshTarget;
      } on NotFoundTargetException catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          skip();
        });

        ///error tutorial exit
        debugPrint("  error>>>>> e ${e.toString()}");
        //debugPrintStack(stackTrace: s);
      }
    }

    if (target == null) {
      return const SizedBox.shrink();
    }

    if (target.offset.dx.isNaN || target.offset.dy.isNaN) {
      return const SizedBox.shrink();
    }

    var positioned = Offset(
      target.offset.dx + target.size.width / 2,
      target.offset.dy + target.size.height / 2,
    );

    double haloWidth;
    double haloHeight;

    if (currentTarget!.shape == ShapeLightFocus.Circle) {
      haloWidth = target.size.width > target.size.height
          ? target.size.width
          : target.size.height;
      haloHeight = haloWidth;
    } else {
      haloWidth = target.size.width;
      haloHeight = target.size.height;
    }

    haloWidth = haloWidth * 0.6 + widget.paddingFocus;
    haloHeight = haloHeight * 0.6 + widget.paddingFocus;

    double width = 0.0;
    double? top;
    double? bottom;
    double? left;
    double? right;

    final ancestorBox = context.findRenderObject() as RenderBox;

    children = currentTarget!.contents!.map<Widget>((i) {
      ContentAlign effectiveAlign = i.align;
      
      // Handle auto alignment
      if (i.align == ContentAlign.auto) {
        effectiveAlign = getAutoAlignment(target!, ancestorBox.size);
      }
      
      switch (effectiveAlign) {
        case ContentAlign.bottom:
          {
            width = ancestorBox.size.width;
            left = 0;
            top = positioned.dy + haloHeight;
            bottom = null;
          }
          break;
        case ContentAlign.top:
          {
            width = ancestorBox.size.width;
            left = 0;
            top = null;
            bottom = haloHeight + (ancestorBox.size.height - positioned.dy);
          }
          break;
        case ContentAlign.left:
          {
            width = positioned.dx - haloWidth;
            left = 0;
            top = positioned.dy - target!.size.height / 2 - haloHeight;
            bottom = null;
          }
          break;
        case ContentAlign.right:
          {
            left = positioned.dx + haloWidth;
            top = positioned.dy - target!.size.height / 2 - haloHeight;
            bottom = null;
            width = ancestorBox.size.width - left!;
          }
          break;
        case ContentAlign.auto:
          // This should never happen as we resolve auto above
          throw StateError('Auto alignment should have been resolved');
        case ContentAlign.custom:
          {
            left = i.customPosition!.left;
            right = i.customPosition!.right;
            top = i.customPosition!.top;
            bottom = i.customPosition!.bottom;
            width = ancestorBox.size.width;
          }
          break;
      }

      return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: SizedBox(
          width: width,
          child: Padding(
            padding: i.padding,
            child: i.builder?.call(context, this) ??
                (i.child ?? const SizedBox.shrink()),
          ),
        ),
      );
    }).toList();

    return Stack(
      children: children,
    );
  }

  Widget _buildSkip() {
    bool isLastTarget = false;

    if (widget.hideSkip) {
      return const SizedBox.shrink();
    }

    if (currentTarget != null) {
      final currentIndex = _focusLightKey.currentState?.currentFocusIndex ?? 0;
      isLastTarget = currentIndex == totalTargets - 1;
    }

    if (isLastTarget && !widget.showSkipInLastTarget) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: currentTarget?.alignSkip ?? widget.alignSkip,
      child: SafeArea(
        bottom: widget.useSafeArea ? true : false,
        top: widget.useSafeArea ? true : false,
        left: widget.useSafeArea ? true : false,
        right: widget.useSafeArea ? true : false,
        child: AnimatedOpacity(
          opacity: showContent ? 1 : 0,
          duration: Durations.medium2,
          child: widget.skipWidget ??
              InkWell(
                onTap: skip,
                child: IgnorePointer(
                  child: widget.skipWidget ??
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          widget.textSkip,
                          style: widget.textStyleSkip,
                        ),
                      ),
                ),
              ),
        ),
      ),
    );
  }

  @override
  void skip() => widget.onClickSkip?.call();

  @override
  void next() => _focusLightKey.currentState?.next();

  @override
  void previous() => _focusLightKey.currentState?.previous();

  void goTo(int index) => _focusLightKey.currentState?.goTo(index);
}
