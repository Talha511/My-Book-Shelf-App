import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:provider/provider.dart' as p;

import 'app.dart';
import 'data/repositories/book_repository_impl.dart';
import 'domain/usecases/book_usecases.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/favorites_viewmodel.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/download_viewmodel.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/auth_usecases.dart';

void main() {
  final bookRepository = BookRepositoryImpl();
  final authRepository = AuthRepositoryImpl();

  final getBooksUseCase = GetBooksUseCase(bookRepository);
  final searchBooksUseCase = SearchBooksUseCase(bookRepository);
  final toggleFavoriteUseCase = ToggleFavoriteUseCase(bookRepository);
  final getFavoritesUseCase = GetFavoritesUseCase(bookRepository);
  final addBookUseCase = AddBookUseCase(bookRepository);

  final loginUseCase = LoginUseCase(authRepository);
  final signupUseCase = SignupUseCase(authRepository);
  final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
  final logoutUseCase = LogoutUseCase(authRepository);
  final updateUserUseCase = UpdateUserUseCase(authRepository);

  runApp(
    p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUseCase: loginUseCase,
            signupUseCase: signupUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            logoutUseCase: logoutUseCase,
            updateUserUseCase: updateUserUseCase,
          ),
        ),
        p.ChangeNotifierProvider(
          create: (_) => HomeViewModel(
            getBooksUseCase: getBooksUseCase,
            searchBooksUseCase: searchBooksUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            addBookUseCase: addBookUseCase,
          ),
        ),
        p.ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
          ),
        ),
        p.ChangeNotifierProvider(
          create: (_) => DownloadViewModel(),
        ),
      ],
      child: const ProviderScope(
        child: MyBookShelfApp(),
      ),
    ),
  );
}
