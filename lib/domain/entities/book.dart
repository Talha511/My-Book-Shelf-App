import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String description;
  final double rating;
  final String imageUrl;
  final String category;
  final String content;
  final bool isFavorite;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.category,
    this.content = '',
    this.isFavorite = false,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    double? rating,
    String? imageUrl,
    String? category,
    String? content,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, author, description, rating, imageUrl, category, content, isFavorite];
}
