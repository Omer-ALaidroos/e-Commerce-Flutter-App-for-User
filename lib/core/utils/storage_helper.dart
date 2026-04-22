
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  final storage = const FlutterSecureStorage();

  Future saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future saveRefreshToken(String refreshToken) async {
    await storage.write(key: 'refreshToken', value: refreshToken);
  }
  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken') ?? "";
  }
  Future<String?> getToken() async {
    return await storage.read(key: 'token') ?? "";
  }

  Future removeToken() async {
    await storage.delete(key: 'token');
  }
}
