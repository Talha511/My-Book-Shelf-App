import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User?> execute(String email, String password) {
    return repository.login(email, password);
  }
}

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<void> execute(User user) {
    return repository.signup(user);
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<User?> execute() {
    return repository.getCurrentUser();
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.logout();
  }
}

class UpdateUserUseCase {
  final AuthRepository repository;
  UpdateUserUseCase(this.repository);

  Future<void> execute(User user) {
    return repository.updateUser(user);
  }
}
