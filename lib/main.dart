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
        ),
        fontFamily: 'Roboto', // Replace with exact font later if needed
        useMaterial3: true,
      ),
      home: const LauncherLayout(),
    );
  }
}
