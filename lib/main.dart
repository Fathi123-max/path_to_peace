import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/home_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/about_screen.dart';
import 'widgets/bottom_nav.dart';
import 'theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FAQScreen(),
    const AboutScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X size as design reference
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            return MaterialApp(
              title: 'Path to Peace',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightDynamic ??
                    ColorScheme.fromSeed(
                      seedColor: AppColors.primaryTeal,
                      brightness: Brightness.light,
                    ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkDynamic ??
                    ColorScheme.fromSeed(
                      seedColor: AppColors.primaryTeal,
                      brightness: Brightness.dark,
                    ),
              ),
              themeMode: ThemeMode.system,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English
                Locale('ar', ''), // Arabic
              ],
              locale: const Locale('en', ''),
              home: Scaffold(
                body: _screens[_currentIndex],
                bottomNavigationBar: BottomNav(
                  currentIndex: _currentIndex,
                  onTap: _onTabTapped,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
