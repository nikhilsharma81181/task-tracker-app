import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/components/custom_btn.dart';
import 'package:task_tracker/provider/theme_prov.dart';
import 'package:task_tracker/view/homepage/homepage.dart';

void main() {
  group('Homepage Widget Test', () {
    late Widget testWidget;

    setUp(() {
      testWidget = MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: const Homepage(),
        ),
      );
    });

    testWidgets('Create Project button shows dialog', (tester) async {
      await tester.pumpWidget(testWidget);

      final createProjectBtn = find.widgetWithText(CustomBtn, 'Create project');

      expect(createProjectBtn, findsOneWidget);

      await tester.tap(createProjectBtn);
      await tester.pumpAndSettle();

      final dialogTitle = find.text('Create Project');
      expect(dialogTitle, findsOneWidget);

      final createBtn = find.widgetWithText(CustomBtn, 'Create');
      expect(createBtn, findsOneWidget);
    });

    testWidgets('Toggling theme icon changes theme', (tester) async {
      await tester.pumpWidget(testWidget);

      final themeIcon = find.byIcon(Icons.light_mode_outlined);
      expect(themeIcon, findsOneWidget);

      await tester.tap(themeIcon);
      await tester.pumpAndSettle();

      final darkThemeIcon = find.byIcon(Icons.dark_mode_outlined);
      expect(darkThemeIcon, findsOneWidget);
    });
  });
}
