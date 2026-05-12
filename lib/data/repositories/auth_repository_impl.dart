import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource = AuthDataSource();
  static const String _userKey = 'current_user';

  @override
  Future<User?> login(String email, String password) async {
    final userModel = await _authDataSource.getUser(email, password);
    if (userModel != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(userModel.toJson()));
      return userModel;
    }
    return null;
  }

  @override
  Future<void> signup(User user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      phoneNumber: user.phoneNumber,
      profileImage: user.profileImage,
    );
    await _authDataSource.saveUser(userModel);
  }

  @override
  Future<bool> userExists(String email) async {
    return await _authDataSource.userExists(email);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      return UserModel.fromJson(json.decode(userString));
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      phoneNumber: user.phoneNumber,
      profileImage: user.profileImage,
    );
    await _authDataSource.updateUser(userModel);
    
    // Update local cache as well
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(userModel.toJson()));
  }
}
