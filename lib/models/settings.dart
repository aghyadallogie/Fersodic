class Settings {
  Settings({required this.userId, required this.userLangs});
  final String userId;
  final List<String> userLangs;

  factory Settings.fromMap(Map<String, dynamic> map) => Settings(
    userId: map['userId'],
    userLangs: List<String>.from(map['languages'] ?? []),
  );
}
