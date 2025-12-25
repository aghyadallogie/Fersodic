import 'package:fersodict/components/flag_button.dart';
import 'package:fersodict/models/language.dart';
import 'package:fersodict/providers/auth_notifier.dart';
import 'package:fersodict/providers/auth_repository_provider.dart';
import 'package:fersodict/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  Future<void> _toggleLanguage(
    BuildContext context,
    WidgetRef ref,
    String langCode,
  ) async {
    try {
      // Get current settings
      final currentSettings = await ref.read(settingsProvider.future);
      if (currentSettings == null) return;

      // Get auth token for user ID
      final token = ref.read(authNotifierProvider).value;
      if (token == null) return;
      final userId = JwtDecoder.decode(token)['sub'] as String;

      // Create new list
      final newUserLangs = List<String>.from(currentSettings.userLangs);
      if (newUserLangs.contains(langCode)) {
        newUserLangs.remove(langCode);
      } else {
        newUserLangs.add(langCode);
      }

      // Update in database
      await ref
          .read(authRepositoryProvider)
          .updateSettings(userId: userId, languages: newUserLangs);

      // Invalidate provider to trigger refresh
      ref.invalidate(settingsProvider);
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update: $error')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (settings) {
          if (settings == null) {
            return const Center(child: Text('Please login'));
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            itemCount: langs.length,
            itemBuilder: (_, i) {
              final lang = langs[i];
              return FlagButton(
                langFlag: lang.flag,
                langCode: lang.code,
                isSelected: settings.userLangs.contains(lang.code),
                onPressed: () => _toggleLanguage(context, ref, lang.code),
              );
            },
          );
        },
      ),
    );
  }
}
