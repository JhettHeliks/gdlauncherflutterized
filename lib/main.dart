import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdlauncherflutterized/src/rust/frb_generated.dart';
import 'views/launcher_layout.dart';
import 'theme/colors.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const ProviderScope(child: MyApp()));
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
        ),
        fontFamily: 'Roboto', // Replace with exact font later if needed
        useMaterial3: true,
      ),
      home: const LauncherLayout(),
    );
  }
}
