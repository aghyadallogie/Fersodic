import 'package:fersodict/components/language_picker.dart';
import 'package:fersodict/components/theme_toggler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_notifier.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          child: const Text('PersoDict'),
        ),
        actions: [
          const ThemeToggle(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: settingsAsync.when(
        data: (settings) {
          print('User languages from DB: ${settings?.userLangs}');

          return Column(
            children: [
              const SizedBox(height: 80),
              Text(
                'Please select at least one language',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              LanguagePicker(),
              const SizedBox(height: 24),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading settings: $error')),
      ),
    );
  }
}
