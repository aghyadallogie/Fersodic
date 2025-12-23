import 'package:fersodict/core/jwt.dart';
import 'package:fersodict/core/secure_storage.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';
import '../models/user.dart';
import 'mongo_service.dart';

/// Repository responsible for user authentication and account creation.
///
/// Provides methods to register users, authenticate credentials and produce
/// JWT tokens. This class uses `MongoService` for persistence and
/// `bcrypt` for password hashing.
class AuthRepository {
  /// Register a new user and return the created user's id as a string.
  ///
  /// Throws [EmailAlreadyRegistered] if an account with [email] already
  /// exists, or [CouldNotInsertUser] if the insertion into the database
  /// fails.
  Future<String> register({
    required String email,
    required String plainPassword,
    String? name,
  }) async {
    await MongoService.open();

    final exists = await MongoService.users.findOne({'email': email});
    if (exists != null) throw EmailAlreadyRegistered();

    final hash = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

    final user = User(
      id: ObjectId(),
      email: email,
      name: name,
      hashedPassword: hash,
    );

    final result = await MongoService.users.insertOne(user.toMap());
    if (!result.isSuccess) throw CouldNotInsertUser();

    return result.id.toString();
  }

  /// Authenticate a user with [email] and [plainPassword].
  ///
  /// On success returns a newly generated JWT token and stores it via
  /// secure storage. Throws [InvalidCredentials] when authentication fails.
  Future<String> login({
    required String email,
    required String plainPassword,
  }) async {
    await MongoService.open();

    final userMap = await MongoService.users.findOne({'email': email});
    if (userMap == null) throw InvalidCredentials();

    final userId = userMap['_id'].toString();
    final token = generateToken(userId);

    final storedHash = userMap['hashedPassword'] as String;
    final matches = BCrypt.checkpw(plainPassword, storedHash);
    if (!matches) throw InvalidCredentials();

    await storeToken(token); // save immediately
    return token;
  }

  /// Convenience method that registers a user then logs them in.
  ///
  /// Returns the authentication token from [login]. Errors from either
  /// method are propagated.
  Future<String> registerAndLogin({
    required String email,
    required String plainPassword,
    String? name,
  }) async {
    await register(email: email, plainPassword: plainPassword, name: name);
    return login(email: email, plainPassword: plainPassword);
  }
}

/// Thrown when the provided credentials are invalid.
class InvalidCredentials implements Exception {}

/// Thrown when an account with the given email already exists.
class EmailAlreadyRegistered implements Exception {}

/// Thrown when creating a new user in the database fails.
class CouldNotInsertUser implements Exception {}
