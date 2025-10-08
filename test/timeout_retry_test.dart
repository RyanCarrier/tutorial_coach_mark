import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void main() {
  group('Target Timeout and Retry Tests', () {
    testWidgets('Tutorial waits for delayed target to appear',
        (WidgetTester tester) async {
      final GlobalKey delayedKey = GlobalKey();
      bool tutorialShowing = false;
      bool showDelayedWidget = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    if (showDelayedWidget)
                      Container(
                        key: delayedKey,
                        width: 100,
                        height: 100,
                        color: Colors.red,
                      ),
                    ElevatedButton(
                      onPressed: () {
                        final tutorial = TutorialCoachMark(
                          targets: [
                            TargetFocus(
                              identify: "delayed-target",
                              keyTarget: delayedKey,
                              contents: [
                                TargetContent(
                                  align: ContentAlign.bottom,
                                  child: const Text("Delayed target"),
                                ),
                              ],
                            ),
                          ],
                          targetWaitTimeout: const Duration(seconds: 2),
                          targetWaitInterval: const Duration(milliseconds: 50),
                          skipOnTargetNotFound: true,
                          onFinish: () {
                            tutorialShowing = false;
                          },
                        );
                        tutorial.show(context: context);
                        tutorialShowing = true;

                        // Show the widget after a delay
                        Future.delayed(const Duration(milliseconds: 300), () {
                          setState(() {
                            showDelayedWidget = true;
                          });
                        });
                      },
                      child: const Text('Start'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Start the tutorial
      await tester.tap(find.text('Start'));
      await tester.pump();

      // Wait for the delayed widget to appear and tutorial to process it
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 100));

      // The tutorial should be showing
      expect(tutorialShowing, isTrue);
      expect(showDelayedWidget, isTrue);
    });

    testWidgets('Tutorial skips target when skipOnTargetNotFound is true',
        (WidgetTester tester) async {
      final GlobalKey missingKey = GlobalKey();
      int finishCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    final tutorial = TutorialCoachMark(
                      targets: [
                        TargetFocus(
                          identify: "missing-target",
                          keyTarget: missingKey,
                          contents: [
                            TargetContent(
                              align: ContentAlign.bottom,
                              child: const Text("Missing target"),
                            ),
                          ],
                        ),
                      ],
                      targetWaitTimeout: const Duration(milliseconds: 200),
                      targetWaitInterval: const Duration(milliseconds: 50),
                      skipOnTargetNotFound: true,
                      onFinish: () {
                        finishCallCount++;
                      },
                    );
                    tutorial.show(context: context);
                  },
                  child: const Text('Start'),
                ),
              );
            },
          ),
        ),
      );

      // Start the tutorial
      await tester.tap(find.text('Start'));
      await tester.pump();

      // Wait for timeout
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Tutorial should have skipped and finished
      expect(finishCallCount, greaterThan(0));
    });

    testWidgets('Tutorial uses custom timeout duration',
        (WidgetTester tester) async {
      final GlobalKey delayedKey = GlobalKey();
      bool showDelayedWidget = false;
      bool tutorialSkipped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    if (showDelayedWidget)
                      Container(
                        key: delayedKey,
                        width: 100,
                        height: 100,
                        color: Colors.red,
                      ),
                    ElevatedButton(
                      onPressed: () {
                        final tutorial = TutorialCoachMark(
                          targets: [
                            TargetFocus(
                              identify: "delayed-target",
                              keyTarget: delayedKey,
                              contents: [
                                TargetContent(
                                  align: ContentAlign.bottom,
                                  child: const Text("Delayed target"),
                                ),
                              ],
                            ),
                          ],
                          // Very short timeout
                          targetWaitTimeout: const Duration(milliseconds: 100),
                          targetWaitInterval: const Duration(milliseconds: 25),
                          skipOnTargetNotFound: true,
                          onFinish: () {
                            tutorialSkipped = true;
                          },
                        );
                        tutorial.show(context: context);

                        // Show widget after timeout expires
                        Future.delayed(const Duration(milliseconds: 200), () {
                          setState(() {
                            showDelayedWidget = true;
                          });
                        });
                      },
                      child: const Text('Start'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Start the tutorial
      await tester.tap(find.text('Start'));
      await tester.pump();

      // Wait past the timeout
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Tutorial should have timed out and skipped
      expect(tutorialSkipped, isTrue);
    });

    testWidgets('Tutorial uses custom retry interval',
        (WidgetTester tester) async {
      final GlobalKey delayedKey = GlobalKey();
      bool showDelayedWidget = false;
      bool tutorialActive = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    if (showDelayedWidget)
                      Container(
                        key: delayedKey,
                        width: 100,
                        height: 100,
                        color: Colors.red,
                      ),
                    ElevatedButton(
                      onPressed: () {
                        final tutorial = TutorialCoachMark(
                          targets: [
                            TargetFocus(
                              identify: "delayed-target",
                              keyTarget: delayedKey,
                              contents: [
                                TargetContent(
                                  align: ContentAlign.bottom,
                                  child: const Text("Delayed target"),
                                ),
                              ],
                            ),
                          ],
                          targetWaitTimeout: const Duration(seconds: 1),
                          // Custom retry interval
                          targetWaitInterval: const Duration(milliseconds: 100),
                          skipOnTargetNotFound: true,
                          onFinish: () {
                            tutorialActive = false;
                          },
                        );
                        tutorial.show(context: context);
                        tutorialActive = true;

                        // Show widget before timeout
                        Future.delayed(const Duration(milliseconds: 300), () {
                          setState(() {
                            showDelayedWidget = true;
                          });
                        });
                      },
                      child: const Text('Start'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Start the tutorial
      await tester.tap(find.text('Start'));
      await tester.pump();

      // Wait for widget to appear
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 100));

      // The tutorial should still be active (not finished/skipped)
      expect(tutorialActive, isTrue);
      expect(showDelayedWidget, isTrue);
    });

    testWidgets('Multiple targets with different availability times',
        (WidgetTester tester) async {
      final GlobalKey immediateKey = GlobalKey();
      final GlobalKey delayedKey = GlobalKey();
      bool showDelayedWidget = false;
      bool tutorialActive = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    Container(
                      key: immediateKey,
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                    ),
                    if (showDelayedWidget)
                      Container(
                        key: delayedKey,
                        width: 100,
                        height: 100,
                        color: Colors.red,
                      ),
                    ElevatedButton(
                      onPressed: () {
                        final tutorial = TutorialCoachMark(
                          targets: [
                            TargetFocus(
                              identify: "immediate-target",
                              keyTarget: immediateKey,
                              contents: [
                                TargetContent(
                                  align: ContentAlign.bottom,
                                  child: const Text("Immediate target"),
                                ),
                              ],
                            ),
                            TargetFocus(
                              identify: "delayed-target",
                              keyTarget: delayedKey,
                              contents: [
                                TargetContent(
                                  align: ContentAlign.bottom,
                                  child: const Text("Delayed target"),
                                ),
                              ],
                            ),
                          ],
                          targetWaitTimeout: const Duration(seconds: 1),
                          targetWaitInterval: const Duration(milliseconds: 50),
                          skipOnTargetNotFound: true,
                          onFinish: () {
                            tutorialActive = false;
                          },
                        );
                        tutorial.show(context: context);
                        tutorialActive = true;

                        // Show delayed widget after a bit
                        Future.delayed(const Duration(milliseconds: 200), () {
                          setState(() {
                            showDelayedWidget = true;
                          });
                        });
                      },
                      child: const Text('Start'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Start the tutorial
      await tester.tap(find.text('Start'));
      await tester.pump();

      // Allow time for tutorial to show first target
      await tester.pump(const Duration(milliseconds: 100));

      // Wait for delayed widget
      await tester.pump(const Duration(milliseconds: 200));

      // Tutorial should still be active
      expect(tutorialActive, isTrue);
      expect(showDelayedWidget, isTrue);
    });

    test('Default timeout values are correct', () {
      final tutorial = TutorialCoachMark(
        targets: [
          TargetFocus(
            identify: "test",
            keyTarget: GlobalKey(),
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                child: const Text("Test"),
              ),
            ],
          ),
        ],
      );

      // Check default values
      expect(tutorial.targetWaitTimeout, const Duration(seconds: 5));
      expect(tutorial.targetWaitInterval, const Duration(milliseconds: 50));
      expect(tutorial.skipOnTargetNotFound, false);
    });

    test('Custom timeout values are applied', () {
      final tutorial = TutorialCoachMark(
        targets: [
          TargetFocus(
            identify: "test",
            keyTarget: GlobalKey(),
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                child: const Text("Test"),
              ),
            ],
          ),
        ],
        targetWaitTimeout: const Duration(seconds: 10),
        targetWaitInterval: const Duration(milliseconds: 100),
        skipOnTargetNotFound: true,
      );

      // Check custom values
      expect(tutorial.targetWaitTimeout, const Duration(seconds: 10));
      expect(tutorial.targetWaitInterval, const Duration(milliseconds: 100));
      expect(tutorial.skipOnTargetNotFound, true);
    });
  });
}
