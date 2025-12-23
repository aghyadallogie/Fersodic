import 'package:fersodict/components/theme_toggler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PersoDict'),
        actions: [
          ThemeToggle(),
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
      body: const Center(child: Text('You are in ! 🎉')),
    );
  }
}
