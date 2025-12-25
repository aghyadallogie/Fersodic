import 'package:fersodict/providers/auth_notifier.dart';
import 'package:fersodict/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/settings.dart';

final settingsProvider = FutureProvider<Settings?>((ref) async {
  final token = ref.watch(authNotifierProvider).value;

  if (token == null) return null;

  final userId = JwtDecoder.decode(token)['sub'] as String;
  final settings = await ref
      .read(authRepositoryProvider)
      .getOrCreateSettings(userId);

  return settings;
});
