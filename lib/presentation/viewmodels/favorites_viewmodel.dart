import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book_usecases.dart';

class FavoritesViewModel extends ChangeNotifier {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoritesViewModel({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  });

  List<Book> _favoriteBooks = [];
  List<Book> get favoriteBooks => _favoriteBooks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    _favoriteBooks = await getFavoritesUseCase.execute();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeFavorite(String bookId) async {
    await toggleFavoriteUseCase.execute(bookId);
    await fetchFavorites();
  }
}
