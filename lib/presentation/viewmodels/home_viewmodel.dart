import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book_usecases.dart';

class HomeViewModel extends ChangeNotifier {
  final GetBooksUseCase getBooksUseCase;
  final SearchBooksUseCase searchBooksUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final AddBookUseCase addBookUseCase;

  HomeViewModel({
    required this.getBooksUseCase,
    required this.searchBooksUseCase,
    required this.toggleFavoriteUseCase,
    required this.addBookUseCase,
  });

  List<Book> _books = [];
  List<Book> get books => _books;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  List<String> _categories = ['All'];
  List<String> get categories => _categories;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    _books = await getBooksUseCase.execute();
    _rebuildCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchBooks(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    _books = await searchBooksUseCase.execute(query);
    if (_selectedCategory != 'All') {
      _books = _books.where((b) => b.category == _selectedCategory).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectCategory(String category) async {
    _selectedCategory = category;
    await searchBooks(_searchQuery);
  }

  Future<void> toggleFavorite(String bookId) async {
    await toggleFavoriteUseCase.execute(bookId);
    await searchBooks(_searchQuery);
  }

  Future<void> addBook({
    required String title,
    required String author,
    required String description,
    required String category,
    String imageUrl = '',
  }) async {
    final book = Book(
      id: const Uuid().v4(),
      title: title,
      author: author,
      description: description,
      category: category.isEmpty ? 'Other' : category,
      rating: 0.0,
      imageUrl: imageUrl,
    );
    await addBookUseCase.execute(book);
    _books = [book, ..._books];
    _rebuildCategories();
    notifyListeners();
  }

  void _rebuildCategories() {
    final Set<String> unique = {'All'};
    for (final b in _books) unique.add(b.category);
    _categories = unique.toList()
      ..sort((a, b) => a == 'All' ? -1 : (b == 'All' ? 1 : a.compareTo(b)));
  }
}
