import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_to_peace/screens/faq_screen.dart';

void main() {
  testWidgets('FAQScreen renders list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            home: FAQScreen(),
          );
        },
      ),
    );

    // Verify that the loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the future to complete
    await tester.pumpAndSettle();

    // Verify that FAQ cards are displayed
    expect(find.text('What does Islam say about peace?'), findsOneWidget);
    expect(find.text('Do Muslims believe in Jesus?'), findsOneWidget);
  });
}