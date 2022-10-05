import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Full Screen Menu Test', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());

      final actionButtonFinder = find.byType(FloatingActionButton);
      expect(actionButtonFinder, findsOneWidget);

      await tester.ensureVisible(actionButtonFinder);

      await tester.tap(actionButtonFinder);

      await tester.pump();

      final snowFinder = find.byIcon(Icons.ac_unit);
      final sunFinder = find.byIcon(Icons.wb_sunny);
      final flashFinder = find.byIcon(Icons.flash_on);
      final grainFinder = find.byIcon(Icons.grain);
      final addFinder = find.byIcon(Icons.add);

      expect(snowFinder, findsOneWidget);
      expect(sunFinder, findsOneWidget);
      expect(flashFinder, findsOneWidget);
      expect(grainFinder, findsOneWidget);
      expect(addFinder, findsWidgets);

      final closeButtonFinder = find.byIcon(Icons.close);

      expect(closeButtonFinder, findsOneWidget);

      await tester.ensureVisible(closeButtonFinder);

      await tester.tap(closeButtonFinder);

      await tester.pump();

    });
  });
}
