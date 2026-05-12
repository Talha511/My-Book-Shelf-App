import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<void> signup(User user);
  Future<bool> userExists(String email);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> updateUser(User user);
}
