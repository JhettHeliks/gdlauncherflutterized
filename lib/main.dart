import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdlauncherflutterized/src/rust/frb_generated.dart';
import 'views/launcher_layout.dart';
import 'theme/colors.dart';
import 'providers/log_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  final container = ProviderContainer();
  await initLogging(container);
  appLogger.i('Application Initialized');
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryAccent,
          surface: AppColors.surface,
          secondary: AppColors.secondaryAccent,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          color: AppColors.surface,
          elevation: 4,
          margin: EdgeInsets.zero,
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: AppColors.surface,
          elevation: 24,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 2,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.w900, fontSize: 57, letterSpacing: -0.25),
          displayMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 45),
          displaySmall: TextStyle(fontWeight: FontWeight.w800, fontSize: 36),
          headlineLarge: TextStyle(fontWeight: FontWeight.w800, fontSize: 32),
          headlineMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          headlineSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          bodyLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
      ),
      home: const LauncherLayout(),
    );
  }
}
