import 'package:fersodict/auth/auth.dart';
import 'package:fersodict/pages/home_page.dart';
import 'package:fersodict/pages/settings_page.dart';
import 'package:fersodict/providers/auth_notifier.dart';
import 'package:fersodict/themes/dark_mode.dart';
import 'package:fersodict/themes/light_mode.dart';
import 'package:fersodict/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authNotifierProvider).value;
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'FersoDict',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      home: token == null ? const Authentication() : const HomePage(),
      routes: {
        '/auth': (_) => const Authentication(),
        '/home': (_) => const HomePage(),
        '/settings': (_) => const SettingsPage(),
      },
    );
  }
}
