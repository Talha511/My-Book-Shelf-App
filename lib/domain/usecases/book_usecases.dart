import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooksUseCase {
  final BookRepository repository;

  GetBooksUseCase(this.repository);

  Future<List<Book>> execute() {
    return repository.getBooks();
  }
}

class SearchBooksUseCase {
  final BookRepository repository;

  SearchBooksUseCase(this.repository);

  Future<List<Book>> execute(String query) {
    return repository.searchBooks(query);
  }
}

class ToggleFavoriteUseCase {
  final BookRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> execute(String bookId) {
    return repository.toggleFavorite(bookId);
  }
}

class GetFavoritesUseCase {
  final BookRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<Book>> execute() {
    return repository.getFavorites();
  }
}

class AddBookUseCase {
  final BookRepository repository;

  AddBookUseCase(this.repository);

  Future<void> execute(Book book) {
    return repository.addBook(book);
  }
}
