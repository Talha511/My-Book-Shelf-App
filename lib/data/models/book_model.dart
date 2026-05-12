import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.description,
    required super.rating,
    required super.imageUrl,
    required super.category,
    super.content = '',
    super.isFavorite,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'rating': rating,
      'imageUrl': imageUrl,
      'category': category,
      'content': content,
      'isFavorite': isFavorite,
    };
  }

  BookModel copyWithModel({
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
    return BookModel(
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
}
