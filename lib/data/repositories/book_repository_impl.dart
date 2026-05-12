import 'dart:convert';
import 'package:flutter/services.dart';
import '../datasources/favorites_datasource.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  List<Book> _books = [];
  final FavoritesDataSource _favoritesDataSource = FavoritesDataSource();

  @override
  Future<List<Book>> getBooks() async {
    if (_books.isNotEmpty) return _books;

    try {
      final String response = await rootBundle.loadString('assets/mock/books.json');
      final List<dynamic> data = json.decode(response);
      _books = data.map((json) => BookModel.fromJson(json)).toList();

      // Load favorite status from database
      final favoriteIds = await _favoritesDataSource.getFavorites();
      _books = _books.map((book) {
        return book.copyWith(isFavorite: favoriteIds.contains(book.id));
      }).toList();

      return _books;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    if (_books.isEmpty) await getBooks();
    if (query.isEmpty) return _books;
    
    return _books.where((book) => 
      book.title.toLowerCase().contains(query.toLowerCase()) ||
      book.author.toLowerCase().contains(query.toLowerCase()) ||
      book.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  Future<List<Book>> getFavorites() async {
    if (_books.isEmpty) await getBooks();
    return _books.where((book) => book.isFavorite).toList();
  }

  @override
  Future<void> toggleFavorite(String bookId) async {
    final isFav = await _favoritesDataSource.isFavorite(bookId);
    if (isFav) {
      await _favoritesDataSource.removeFavorite(bookId);
    } else {
      await _favoritesDataSource.addFavorite(bookId);
    }
    _books = _books.map((book) {
      if (book.id == bookId) return book.copyWith(isFavorite: !isFav);
      return book;
    }).toList();
  }

  @override
  Future<void> addBook(Book book) async {
    _books = [book, ..._books];
  }
}
