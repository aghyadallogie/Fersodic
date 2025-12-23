import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final _secret = dotenv.env['JWT_SECRET'];

String generateToken(String userId) {
  final header = {'alg': 'HS256', 'typ': 'JWT'};
  final payload = {
    'sub': userId,
    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'exp':
        DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/
        1000,
  };

  String encode(Map json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final String signature = Hmac(
    sha256,
    utf8.encode(_secret!),
  ).convert(utf8.encode('${encode(header)}.${encode(payload)}')).toString();

  return '${encode(header)}.${encode(payload)}.${base64Url.encode(signature.codeUnits).replaceAll('=', '')}';
}

bool isTokenValid(String token) => !JwtDecoder.isExpired(token);
