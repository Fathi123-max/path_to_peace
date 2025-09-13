import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_to_peace/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen loads quote', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            home: HomeScreen(),
          );
        },
      ),
    );

    // Verify that the loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the future to complete
    await tester.pumpAndSettle();

    // Verify that the quote card is displayed
    expect(find.text('Indeed, my Lord is upon a straight path.'), findsOneWidget);
    expect(find.text('Quran 6:79'), findsOneWidget);
  });
}