import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.updateUserUseCase,
  }) {
    _loadCurrentUser();
  }

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> _loadCurrentUser() async {
    _currentUser = await getCurrentUserUseCase.execute();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await loginUseCase.execute(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An error occurred during login';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(User user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await signupUseCase.execute(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create account. Email might already be in use.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await logoutUseCase.execute();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    _currentUser = await getCurrentUserUseCase.execute();
    notifyListeners();
  }

  void updateProfileImage(String imagePath) async {
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        password: _currentUser!.password,
        phoneNumber: _currentUser!.phoneNumber,
        profileImage: imagePath,
      );
      
      _currentUser = updatedUser;
      notifyListeners();
      
      // Persist to DB and SharedPreferences
      await updateUserUseCase.execute(updatedUser);
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Google Sign In failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Facebook Sign In failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Apple Sign In failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
