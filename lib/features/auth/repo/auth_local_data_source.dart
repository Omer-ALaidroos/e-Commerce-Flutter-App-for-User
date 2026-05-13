import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  static const String _userIdKey = 'user_id';

  AuthLocalDataSource(this._storage);

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  Future<String?> getUserId() async {
    String? id = await _storage.read(key: _userIdKey);
    return id;
  }

  Future<void> clearData() async {
    await _storage.delete(key: _userIdKey);
  }
}