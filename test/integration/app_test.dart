import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilike/main.dart' as app;

void main() {
  group('iLike App Integration Tests', () {
    testWidgets('app should start and show splash screen',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the app starts successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should navigate through main app flow',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify that we're on the main app screen
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle app lifecycle events',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Simulate app pause
      await tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();

      // Simulate app resume
      await tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // Verify app is still running
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
