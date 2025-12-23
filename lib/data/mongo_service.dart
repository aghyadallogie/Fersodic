import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoService {
  static final _connectionString = dotenv.env['MONGO_URI'];
  static Db? _db;
  static DbCollection get users => _db!.collection('User');

  static Future<void> open() async {
    if (_db != null && _db!.isConnected) return;
    _db = await Db.create(MongoService._connectionString!);
    await _db!.open();
    debugPrint('Mongo connected');
  }

  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
