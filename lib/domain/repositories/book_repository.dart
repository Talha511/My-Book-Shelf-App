import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks();
  Future<List<Book>> searchBooks(String query);
  Future<List<Book>> getFavorites();
  Future<void> toggleFavorite(String bookId);
  Future<void> addBook(Book book);
}
