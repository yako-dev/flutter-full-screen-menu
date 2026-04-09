import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:full_screen_menu/src/widgets/full_screen_menu_base_widget.dart';
import 'package:full_screen_menu/full_screen_menu.dart';

void main() {
  group('Full screen menu tests', () {
    AnimationController? _animationController;
    bool sunnyIsPressed = false;
    bool snowIsPressed = false;
    bool materialIsPressed = false;
    final floatingActionButton = Builder(
      builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () => showFullScreenMenu(context),
          child: Icon(Icons.add),
        );
      },
    );

    final fullScreenMenuWidget = FullScreenMenuBaseWidget(
      onHide: FullScreenMenuUtil.dismiss,
      backgroundColor: Colors.black,
      animationController: (animation) {
        _animationController = animation;
      },
      items: [
        FSMenuItem(
          icon: Icon(Icons.wb_sunny, color: Colors.white),
          text: Text('Make hotter', style: TextStyle(color: Colors.white)),
          gradient: redGradient,
          onTap: () {
            sunnyIsPressed = true;
          },
        ),
        FSMenuItem(
          icon: Icon(Icons.ac_unit, color: Colors.white),
          text: Text('Make colder', style: TextStyle(color: Colors.white)),
          gradient: blueGradient,
          onTap: () {
            snowIsPressed = true;
          },
        ),
        MaterialButton(
          onPressed: () {
            materialIsPressed = true;
          },
          color: Colors.blue,
          child: Text('Material'),
        ),
      ],
    );

    testWidgets('Full Screen Menu is showed', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(floatingActionButton));
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(find.byType(FullScreenMenuBaseWidget), findsOneWidget);
      });
    });

    testWidgets('Widget should render correctly', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byType(FullScreenMenuBaseWidget), findsOneWidget);
      });
    });

    testWidgets('Items of menu should render correctly', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byType(FSMenuItem), findsWidgets);
      });
    });

    testWidgets('Sunny item icon should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });
    });

    testWidgets('Sunny item text should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.text('Make hotter'), findsOneWidget);
      });
    });

    testWidgets('Sunny item text color should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        final textWidget = tester.widget<Text>(find.text('Make hotter'));
        expect(textWidget.style?.color, Colors.white);
      });
    });

    testWidgets('Sunny item gradient should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));
        final fSMenuItem = tester.widget<FSMenuItem>(find.widgetWithIcon(
          FSMenuItem,
          Icons.wb_sunny,
        ));

        expect(fSMenuItem.gradient, redGradient);
      });
    });

    testWidgets('Sunny item onTap is called', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        await tester.tap(find.widgetWithIcon(FSMenuItem, Icons.wb_sunny));
        await tester.pump();

        expect(sunnyIsPressed, true);
      });
    });

    testWidgets('Snow item icon should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byIcon(Icons.ac_unit), findsOneWidget);
      });
    });

    testWidgets('Snow item text should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.text('Make colder'), findsOneWidget);
      });
    });

    testWidgets('Snow item text color should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        final textWidget = tester.widget<Text>(find.text('Make colder'));
        expect(textWidget.style?.color, Colors.white);
      });
    });

    testWidgets('Snow item gradient should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));
        final fSMenuItem = tester.widget<FSMenuItem>(find.widgetWithIcon(
          FSMenuItem,
          Icons.ac_unit,
        ));

        expect(fSMenuItem.gradient, blueGradient);
      });
    });

    testWidgets('Snow item onTap is called', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        await tester.tap(find.widgetWithIcon(FSMenuItem, Icons.ac_unit));
        await tester.pump();

        expect(snowIsPressed, true);
      });
    });

    testWidgets('Close FAB of menu should render correctly', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });

    testWidgets('Close FAB icon should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(
          find.widgetWithIcon(FloatingActionButton, Icons.close),
          findsOneWidget,
        );
      });
    });

    testWidgets('Close FAB background color should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));
        final fabFinder =
            find.widgetWithIcon(FloatingActionButton, Icons.close);
        final floatingActionButton =
            tester.widget<FloatingActionButton>(fabFinder);

        expect(floatingActionButton.backgroundColor, Colors.white);
      });
    });

    testWidgets('Material button should render correctly', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));
        final materialButtonFinder = find.byType(MaterialButton);

        expect(materialButtonFinder, findsOneWidget);
      });
    });

    testWidgets('Material button color should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));
        final materialButtonFinder = find.byType(MaterialButton);
        final materialButtonWidget =
            tester.widget<MaterialButton>(materialButtonFinder);

        expect(materialButtonWidget.color, Colors.blue);
      });
    });

    testWidgets('Material button text should match', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        expect(find.text('Material'), findsOneWidget);
      });
    });

    testWidgets('Material button onTap is called', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapWithMaterialApp(fullScreenMenuWidget));

        await tester.tap(find.byType(MaterialButton));
        await tester.pump();

        expect(materialIsPressed, true);
      });
    });
  });
}

void showFullScreenMenu(BuildContext context) {
  FullScreenMenu.show(
    context,
    backgroundColor: Colors.black,
    closeMenuOnBackgroundTap: true,
    items: [
      FSMenuItem(
        icon: Icon(Icons.wb_sunny, color: Colors.white),
        text: Text('Make hotter', style: TextStyle(color: Colors.white)),
        gradient: redGradient,
        onTap: () {},
      ),
    ],
  );
}

Widget _wrapWithMaterialApp(Widget testWidget) {
  return MaterialApp(
    home: Scaffold(
      body: testWidget,
    ),
  );
}
