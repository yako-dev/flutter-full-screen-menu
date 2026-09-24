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
}
