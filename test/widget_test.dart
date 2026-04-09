import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';
import 'package:full_screen_menu/full_screen_menu.dart';

void main() {
  tearDown(() {
    // Reset global state between tests.
    FullScreenMenuUtil.isVisible = false;
    FullScreenMenuUtil.entry = null;
    FullScreenMenuUtil.state = null;
  });

  group('FullScreenMenu static API', () {
    testWidgets('show() inserts the menu into the overlay', (tester) async {
      await tester.pumpWidget(_buildApp(
        Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => FullScreenMenu.show(
              context,
              backgroundColor: Colors.black,
              items: [
                FSMenuItem(
                  icon: const Icon(Icons.wb_sunny, color: Colors.white),
                  text: const Text('Sunny'),
                  gradient: redGradient,
                  onTap: () {},
                ),
              ],
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(FullScreenMenuBaseWidget), findsOneWidget);
      expect(FullScreenMenu.isVisible, isTrue);
    });

    testWidgets('isVisible returns false before show()', (tester) async {
      await tester.pumpWidget(_buildApp(const SizedBox()));
      expect(FullScreenMenu.isVisible, isFalse);
    });

    testWidgets('show() with closeMenuOnBackgroundTap=false does not close on tap',
        (tester) async {
      await tester.pumpWidget(_buildApp(
        Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => FullScreenMenu.show(
              context,
              backgroundColor: Colors.black,
              closeMenuOnBackgroundTap: false,
              items: const [],
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(FullScreenMenu.isVisible, isTrue);
      // Tapping background should NOT close the menu.
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(FullScreenMenu.isVisible, isTrue);
    });
  });

  group('FullScreenMenuBaseWidget', () {
    late bool sunnyPressed;
    late bool snowPressed;

    setUp(() {
      sunnyPressed = false;
      snowPressed = false;
    });

    Widget buildMenu() => FullScreenMenuBaseWidget(
          onHide: FullScreenMenuUtil.dismiss,
          backgroundColor: Colors.black,
          animationController: (_) {},
          items: [
            FSMenuItem(
              icon: const Icon(Icons.wb_sunny, color: Colors.white),
              text: const Text(
                'Make hotter',
                style: TextStyle(color: Colors.white),
              ),
              gradient: redGradient,
              onTap: () => sunnyPressed = true,
            ),
            FSMenuItem(
              icon: const Icon(Icons.ac_unit, color: Colors.white),
              text: const Text(
                'Make colder',
                style: TextStyle(color: Colors.white),
              ),
              gradient: blueGradient,
              onTap: () => snowPressed = true,
            ),
            MaterialButton(
              onPressed: () {},
              color: Colors.blue,
              child: const Text('Material'),
            ),
          ],
        );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.byType(FullScreenMenuBaseWidget), findsOneWidget);
    });

    testWidgets('renders FSMenuItems', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.byType(FSMenuItem), findsNWidgets(2));
    });

    testWidgets('renders items with no items list (no crash)', (tester) async {
      await tester.pumpWidget(_buildApp(
        FullScreenMenuBaseWidget(
          backgroundColor: Colors.black,
          animationController: (_) {},
        ),
      ));
      expect(find.byType(FullScreenMenuBaseWidget), findsOneWidget);
    });

    testWidgets('sunny icon is rendered', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
    });

    testWidgets('sunny text is rendered', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.text('Make hotter'), findsOneWidget);
    });

    testWidgets('sunny text color is white', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      final text = tester.widget<Text>(find.text('Make hotter'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('sunny gradient matches', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      final item = tester.widget<FSMenuItem>(
        find.widgetWithIcon(FSMenuItem, Icons.wb_sunny),
      );
      expect(item.gradient, redGradient);
    });

    testWidgets('sunny onTap fires', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      await tester.tap(find.widgetWithIcon(FSMenuItem, Icons.wb_sunny));
      await tester.pump();
      expect(sunnyPressed, isTrue);
    });

    testWidgets('snow icon is rendered', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    });

    testWidgets('snow text is rendered', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.text('Make colder'), findsOneWidget);
    });

    testWidgets('snow text color is white', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      final text = tester.widget<Text>(find.text('Make colder'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('snow gradient matches', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      final item = tester.widget<FSMenuItem>(
        find.widgetWithIcon(FSMenuItem, Icons.ac_unit),
      );
      expect(item.gradient, blueGradient);
    });

    testWidgets('snow onTap fires', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      await tester.tap(find.widgetWithIcon(FSMenuItem, Icons.ac_unit));
      await tester.pump();
      expect(snowPressed, isTrue);
    });

    testWidgets('close FAB is rendered', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(
        find.widgetWithIcon(FloatingActionButton, Icons.close),
        findsOneWidget,
      );
    });

    testWidgets('close FAB background color is white', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      final fab = tester.widget<FloatingActionButton>(
        find.widgetWithIcon(FloatingActionButton, Icons.close),
      );
      expect(fab.backgroundColor, Colors.white);
    });

    testWidgets('MaterialButton is rendered', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.byType(MaterialButton), findsOneWidget);
    });

    testWidgets('MaterialButton color is blue', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      final btn = tester.widget<MaterialButton>(find.byType(MaterialButton));
      expect(btn.color, Colors.blue);
    });

    testWidgets('MaterialButton text is rendered', (tester) async {
      await tester.pumpWidget(_buildApp(buildMenu()));
      expect(find.text('Material'), findsOneWidget);
    });
  });

  group('FSMenuItem', () {
    testWidgets('renders icon and text', (tester) async {
      await tester.pumpWidget(_buildApp(
        FSMenuItem(
          icon: const Icon(Icons.star),
          text: const Text('Star'),
          gradient: orangeGradient,
          onTap: () {},
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Star'), findsOneWidget);
    });

    testWidgets('uses blueGrey gradient when none provided', (tester) async {
      await tester.pumpWidget(_buildApp(
        FSMenuItem(onTap: () {}),
      ));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FSMenuItem),
          matching: find.byType(Container),
        ),
      );
      expect(
        (container.decoration as BoxDecoration).gradient,
        blueGreyGradient,
      );
    });

    testWidgets('onTap fires', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_buildApp(
        FSMenuItem(
          icon: const Icon(Icons.star),
          onTap: () => tapped = true,
        ),
      ));
      // Invoke the GestureDetector's onTap directly — FSMenuItem renders as a
      // small Column inside a Scaffold body which makes hit-testing unreliable.
      // The wiring onTap → GestureDetector.onTap is what we're verifying here.
      tester
          .firstWidget<GestureDetector>(
            find.descendant(
              of: find.byType(FSMenuItem),
              matching: find.byType(GestureDetector),
            ),
          )
          .onTap!();
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('copyWith overrides fields', (tester) async {
      final original = FSMenuItem(
        text: const Text('original'),
        onTap: () {},
        gradient: blueGradient,
      );
      final copy = original.copyWith(text: const Text('copy'));
      expect(copy.gradient, blueGradient);
      await tester.pumpWidget(_buildApp(copy));
      expect(find.text('copy'), findsOneWidget);
    });
  });
}

Widget _buildApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}
