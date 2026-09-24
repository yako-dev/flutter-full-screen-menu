import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';

late BuildContext _context;

/// An app whose home screen stores its context in [_context], so tests can
/// call [FullScreenMenu.show] directly. [padding] simulates the status bar and
/// home indicator insets.
Widget _app({Widget? body, EdgeInsets padding = EdgeInsets.zero}) {
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: padding,
        viewPadding: padding,
      ),
      child: child!,
    ),
    home: Builder(
      builder: (context) {
        _context = context;
        return Scaffold(body: body ?? const SizedBox.expand());
      },
    ),
  );
}

void main() {
  tearDown(() {
    // Reset global state between tests.
    FullScreenMenuUtil.isVisible = false;
    FullScreenMenuUtil.entry = null;
    FullScreenMenuUtil.state = null;
  });

  testWidgets('show() works again after the app that held the menu is replaced',
      (tester) async {
    await tester.pumpWidget(_app());
    FullScreenMenu.show(_context, items: const []);
    await tester.pumpAndSettle();

    // Replace the whole app while the menu is open: its overlay is disposed
    // without dismiss() being called.
    await tester.pumpWidget(const SizedBox());
    expect(FullScreenMenu.isVisible, isFalse);

    await tester.pumpWidget(_app());
    FullScreenMenu.show(_context, items: const [Text('again')]);
    await tester.pumpAndSettle();
    expect(FullScreenMenu.isVisible, isTrue);
    expect(find.text('again'), findsOneWidget);
  });

  group('hide()', () {
    testWidgets('does not throw after the close button closed the menu',
        (tester) async {
      await tester.pumpWidget(_app());
      FullScreenMenu.show(_context, items: const []);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(FullScreenMenu.isVisible, isFalse);

      // Used to call reverse() on the disposed AnimationController.
      FullScreenMenu.hide();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not throw when called twice', (tester) async {
      await tester.pumpWidget(_app());
      FullScreenMenu.show(_context, items: const []);
      await tester.pumpAndSettle();
      FullScreenMenu.hide();
      await tester.pump(const Duration(milliseconds: 300));
      expect(FullScreenMenu.isVisible, isFalse);
      FullScreenMenu.hide();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets('closes a menu hidden before its first frame', (tester) async {
      await tester.pumpWidget(_app());
      FullScreenMenu.show(_context, items: const []);
      FullScreenMenu.hide();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(FullScreenMenu.isVisible, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a second call does not close a menu opened afterwards',
        (tester) async {
      await tester.pumpWidget(_app());
      FullScreenMenu.show(_context, items: const []);
      await tester.pumpAndSettle();
      FullScreenMenu.hide(); // Menu is removed at 200 ms.
      await tester.pump(const Duration(milliseconds: 100));
      FullScreenMenu.hide(); // Used to remove "the" menu again at 300 ms.
      await tester.pump(const Duration(milliseconds: 150));
      expect(FullScreenMenu.isVisible, isFalse);

      FullScreenMenu.show(_context, items: const [Text('second')]);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(FullScreenMenu.isVisible, isTrue);
      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('show() during the closing animation opens the new menu',
        (tester) async {
      await tester.pumpWidget(_app());
      FullScreenMenu.show(_context, items: const [Text('first')]);
      await tester.pumpAndSettle();
      FullScreenMenu.hide();
      await tester.pump(const Duration(milliseconds: 100));

      // Used to be ignored because the closing menu still counted as visible.
      FullScreenMenu.show(_context, items: const [Text('second')]);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(FullScreenMenu.isVisible, isTrue);
      expect(find.text('first'), findsNothing);
      expect(find.text('second'), findsOneWidget);
    });
  });

  testWidgets('pressing the close button twice does not close the next menu',
      (tester) async {
    await tester.pumpWidget(_app());
    FullScreenMenu.show(_context, items: const []);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close)); // Menu is removed at 200 ms.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.close)); // Used to dismiss at 300 ms.
    await tester.pump(const Duration(milliseconds: 150));
    expect(FullScreenMenu.isVisible, isFalse);

    FullScreenMenu.show(_context, items: const [Text('second')]);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(FullScreenMenu.isVisible, isTrue);
    expect(find.text('second'), findsOneWidget);
  });

  group('safe area', () {
    const insets = EdgeInsets.only(top: 40, bottom: 30);

    testWidgets('the background covers the status bar and home indicator',
        (tester) async {
      await tester.pumpWidget(_app(padding: insets));
      FullScreenMenu.show(_context, backgroundColor: Colors.black);
      await tester.pumpAndSettle();

      final background = find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color ==
                Colors.black.withAlpha(217),
      );
      expect(tester.getRect(background), Offset.zero & const Size(800, 600));

      // The close button still stays clear of the home indicator.
      final close = tester.getRect(find.byType(FloatingActionButton));
      expect(close.bottom, lessThanOrEqualTo(600 - 30 - 35));
    });

    testWidgets('taps in the insets do not reach the app below',
        (tester) async {
      var appTaps = 0;
      await tester.pumpWidget(_app(
        padding: insets,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => appTaps++,
          child: const SizedBox.expand(),
        ),
      ));
      FullScreenMenu.show(_context, closeMenuOnBackgroundTap: false);
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(400, 10)); // Status bar.
      await tester.tapAt(const Offset(400, 590)); // Home indicator.
      await tester.pump();
      expect(appTaps, 0);
      expect(FullScreenMenu.isVisible, isTrue);
    });

    testWidgets('a tap in the status bar area closes the menu', (tester) async {
      await tester.pumpWidget(_app(padding: insets));
      FullScreenMenu.show(_context);
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(400, 10));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(FullScreenMenu.isVisible, isFalse);
    });
  });
}
