import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _key = 'jwt';

final FlutterSecureStorage _storage = const FlutterSecureStorage();

Future<void> storeToken(String token) =>
    _storage.write(key: _key, value: token);

Future<String?> getToken() => _storage.read(key: _key);

Future<void> deleteToken() => _storage.delete(key: _key);
