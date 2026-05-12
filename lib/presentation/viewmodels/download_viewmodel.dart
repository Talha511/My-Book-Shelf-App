import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/book.dart';
import '../../data/repositories/book_repository_impl.dart';

class DownloadViewModel extends ChangeNotifier {
  final List<Book> _downloadedBooks = [];
  List<Book> get downloadedBooks => _downloadedBooks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final BookRepositoryImpl _repository = BookRepositoryImpl();

  Future<void> fetchDownloadedBooks() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final List<String> downloadedIds = prefs.getStringList('downloaded_books') ?? [];

    _downloadedBooks.clear();
    // In a real app, you'd fetch from local DB. 
    // Here we'll simulate by getting from repository for the sake of demo.
    final allBooks = await _repository.getBooks();
    for (var id in downloadedIds) {
      final book = allBooks.firstWhere((b) => b.id == id);
      _downloadedBooks.add(book);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> downloadBook(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> downloadedIds = prefs.getStringList('downloaded_books') ?? [];

    if (!downloadedIds.contains(book.id)) {
      downloadedIds.add(book.id);
      await prefs.setStringList('downloaded_books', downloadedIds);
      _downloadedBooks.add(book);
      notifyListeners();
    }
  }

  Future<void> removeDownloadedBook(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> downloadedIds = prefs.getStringList('downloaded_books') ?? [];

    if (downloadedIds.contains(bookId)) {
      downloadedIds.remove(bookId);
      await prefs.setStringList('downloaded_books', downloadedIds);
      _downloadedBooks.removeWhere((b) => b.id == bookId);
      notifyListeners();
    }
  }

  bool isDownloaded(String bookId) {
    return _downloadedBooks.any((b) => b.id == bookId);
  }
}
