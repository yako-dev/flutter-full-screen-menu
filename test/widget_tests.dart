import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_menu/src/models/gradients.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/widgets/fs_menu_item.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';

void main() {
  group('Full screen menu tests', () {
    final fullScreenMenuWidget = FullScreenMenuBaseWidget(
      onHide: FullScreenMenuUtil.dismiss,
      backgroundColor: Colors.black,
      items: [
        FSMenuItem(
          icon: Icon(Icons.wb_sunny, color: Colors.white),
          text: Text('Make hotter', style: TextStyle(color: Colors.white)),
          gradient: redGradient,
        ),
      ],
    );

    testWidgets('Widget should render correctly', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byType(FullScreenMenuBaseWidget), findsOneWidget);
      });
    });

    testWidgets('Item of menu should render correctly', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byType(FSMenuItem), findsOneWidget);
      });
    });

    testWidgets('Item icon should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });
    });

    testWidgets('Item text should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.text('Make hotter'), findsOneWidget);
      });
    });

    testWidgets('Item text color should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        final textWidget = tester.widget<Text>(find.text('Make hotter'));
        expect(textWidget.style?.color, Colors.white);
      });
    });

    testWidgets('Item gradient should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));
        final fSMenuItem = tester.widget<FSMenuItem>(find.byType(FSMenuItem));

        expect(fSMenuItem.gradient, redGradient);
      });
    });
  });
}

Widget _wrapWithMaterialApp(Widget testWidget) {
  return MaterialApp(home: testWidget);
}
