// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorialCoachMark Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DemoListPage(),
    );
  }
}

class DemoListPage extends StatelessWidget {
  const DemoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial Coach Mark Demos'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Basic Tutorial Demo'),
            subtitle: const Text('Standard tutorial with multiple targets'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Timeout & Retry Demo'),
            subtitle: const Text('Demonstrates waiting for delayed widgets'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TimeoutDemoPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late TutorialCoachMark tutorialCoachMark;
  bool _useBuilder = false;

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();

  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            // key: keyButton1,
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          PopupMenuButton(
            key: keyButton1,
            icon: const Icon(Icons.view_list, color: Colors.black),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Is this"),
              ),
              const PopupMenuItem(
                child: Text("What"),
              ),
              const PopupMenuItem(
                child: Text("You Want?"),
              ),
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  key: keyButton,
                  color: Colors.blue,
                  height: 100,
                  width: MediaQuery.of(context).size.width - 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          child: const Icon(Icons.remove_red_eye),
                          onPressed: () {
                            showTutorial();
                          },
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          child:
                              Text(_useBuilder ? 'Use Static' : 'Use Builder'),
                          onPressed: () {
                            setState(() {
                              _useBuilder = !_useBuilder;
                              createTutorial();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  key: keyButton2,
                  onPressed: () {},
                  child: Container(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    key: keyButton3,
                    onPressed: () {},
                    child: Container(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    key: keyButton4,
                    onPressed: () {},
                    child: Container(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    key: keyButton5,
                    onPressed: () {},
                    child: Container(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: Center(
                  child: SizedBox(
                    key: keyBottomNavigation1,
                    height: 40,
                    width: 40,
                  ),
                )),
                Expanded(
                    child: Center(
                  child: SizedBox(
                    key: keyBottomNavigation2,
                    height: 40,
                    width: 40,
                  ),
                )),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      key: keyBottomNavigation3,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Business',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'School',
              ),
            ],
            // currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (index) {},
          ),
        ],
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    if (_useBuilder) {
      tutorialCoachMark = TutorialCoachMark(
        targetsBuilder: (index, context) {
          final targets = _createTargets();
          if (index >= 0 && index < targets.length) {
            final target = targets[index];
            // Demonstrate dynamic modification - change the color based on index
            return TargetFocus(
              identify: "${target.identify} (builder)",
              keyTarget: target.keyTarget,
              targetPosition: target.targetPosition,
              contents: target.contents,
              shape: target.shape,
              radius: target.radius,
              borderSide: target.borderSide,
              color: index.isEven ? Colors.green : Colors.purple,
              enableOverlayTab: target.enableOverlayTab,
              enableTargetTab: target.enableTargetTab,
              alignSkip: target.alignSkip,
              paddingFocus: target.paddingFocus,
              focusAnimationDuration: target.focusAnimationDuration,
              unFocusAnimationDuration: target.unFocusAnimationDuration,
              pulseVariation: target.pulseVariation,
            );
          }
          return null;
        },
        targetCount: _createTargets().length,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.5,
        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        onFinish: () {
          print("finish");
        },
        onClickTarget: (target) {
          print('onClickTarget: $target');
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          print("target: $target");
          print(
              "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        onClickOverlay: (target) {
          print('onClickOverlay: $target');
        },
        onSkip: () {
          print("skip");
          return true;
        },
      );
    } else {
      tutorialCoachMark = TutorialCoachMark(
        targets: _createTargets(),
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.5,
        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        onFinish: () {
          print("finish");
        },
        onClickTarget: (target) {
          print('onClickTarget: $target');
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          print("target: $target");
          print(
              "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        onClickOverlay: (target) {
          print('onClickOverlay: $target');
        },
        onSkip: () {
          print("skip");
          return true;
        },
      );
    }
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: keyBottomNavigation3,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      tutorialCoachMark.goTo(0);
                    },
                    child: const Text('Go to index 0'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton1,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton,
        color: Colors.purple,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.previous();
                    },
                    child: const Icon(Icons.chevron_left),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyButton4,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Multiples content",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          TargetContent(
              align: ContentAlign.top,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Multiples content",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ))
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: keyButton5,
      contents: [
        TargetContent(
            align: ContentAlign.right,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Title lorem ipsum",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: keyButton3,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  tutorialCoachMark.previous();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(
                    "https://juststickers.in/wp-content/uploads/2019/01/flutter.png",
                    height: 200,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Image Load network",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(
      TargetFocus(
        identify: "Target 5",
        keyTarget: keyButton2,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.auto,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Auto Alignment Demo",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "This content uses auto alignment - it will be positioned automatically based on available space!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          TargetContent(
              align: ContentAlign.bottom,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Fixed Bottom Content",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Text(
                    "This content is always at the bottom for comparison.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ))
        ],
      ),
    );

    return targets;
  }
}

/// Demo page that shows timeout and retry functionality
class TimeoutDemoPage extends StatefulWidget {
  const TimeoutDemoPage({Key? key}) : super(key: key);

  @override
  State<TimeoutDemoPage> createState() => _TimeoutDemoPageState();
}

class _TimeoutDemoPageState extends State<TimeoutDemoPage> {
  final GlobalKey _delayedButtonKey = GlobalKey();
  final GlobalKey _immediateButtonKey = GlobalKey();
  bool _showDelayedButton = false;
  late TutorialCoachMark _tutorial;
  String _statusMessage = 'Ready to start tutorial';

  @override
  void initState() {
    super.initState();
    _createTutorial();
  }

  void _createTutorial() {
    _tutorial = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "immediate-button",
          keyTarget: _immediateButtonKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Immediate Target",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This target is immediately visible.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: "delayed-button",
          keyTarget: _delayedButtonKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Delayed Target",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This target appears after a delay. The tutorial waited for it!",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      // Wait up to 3 seconds for targets to appear
      targetWaitTimeout: const Duration(seconds: 3),
      // Check every 100ms
      targetWaitInterval: const Duration(milliseconds: 100),
      // Skip targets that don't appear in time (set to false to throw exception)
      skipOnTargetNotFound: true,
      colorShadow: Colors.blue,
      opacityShadow: 0.8,
      onFinish: () {
        setState(() {
          _statusMessage = 'Tutorial finished!';
        });
        print("Tutorial finished");
      },
      onSkip: () {
        setState(() {
          _statusMessage = 'Tutorial skipped';
        });
        print("Tutorial skipped");
        return true;
      },
    );
  }

  void _startTutorialWithDelay() {
    setState(() {
      _statusMessage = 'Tutorial started - waiting for delayed button...';
      _showDelayedButton = false;
    });

    // Show the tutorial immediately
    _tutorial.show(context: context);

    // Show the delayed button after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showDelayedButton = true;
          _statusMessage = 'Delayed button appeared!';
        });
      }
    });
  }

  void _startTutorialWithoutDelay() {
    setState(() {
      _statusMessage = 'Tutorial started - all buttons visible';
      _showDelayedButton = true;
    });

    _tutorial.show(context: context);
  }

  void _startTutorialWithTimeout() {
    setState(() {
      _statusMessage =
          'Tutorial started - button will NOT appear (testing timeout)';
      _showDelayedButton = false;
    });

    // Create a tutorial with a shorter timeout
    final timeoutTutorial = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "immediate-button",
          keyTarget: _immediateButtonKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "First Target",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: "delayed-button",
          keyTarget: _delayedButtonKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "This won't be shown",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      targetWaitTimeout: const Duration(seconds: 2),
      targetWaitInterval: const Duration(milliseconds: 100),
      skipOnTargetNotFound: true, // Skip the missing target
      colorShadow: Colors.red,
      opacityShadow: 0.8,
      onFinish: () {
        setState(() {
          _statusMessage =
              'Tutorial finished (second target was skipped due to timeout)';
        });
      },
    );

    timeoutTutorial.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeout & Retry Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Tutorial Configuration:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Timeout: 3 seconds'),
                  const Text('• Retry Interval: 100ms'),
                  const Text('• Skip on timeout: true'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              key: _immediateButtonKey,
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Always Visible Button',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _showDelayedButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _showDelayedButton
                  ? ElevatedButton(
                      key: _delayedButtonKey,
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Delayed Button (2s)',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: const Center(
                        child: Text(
                          '(Button will appear after 2 seconds)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _startTutorialWithDelay,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Tutorial\n(with delay)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _startTutorialWithoutDelay,
                  icon: const Icon(Icons.fast_forward),
                  label: const Text('Start Tutorial\n(no delay)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _startTutorialWithTimeout,
                  icon: const Icon(Icons.timer_off),
                  label: const Text('Test Timeout\n(skip mode)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Try different scenarios:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. "with delay" - Tutorial waits for the button\n'
              '2. "no delay" - Both buttons visible immediately\n'
              '3. "Test Timeout" - Second target never appears',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
