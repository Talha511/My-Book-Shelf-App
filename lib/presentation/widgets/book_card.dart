import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/book.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'rating_stars.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isDark
              ? Border.all(color: AppColors.secondary.withValues(alpha: 0.25))
              : null,
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'book-${book.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: CachedNetworkImage(
                        imageUrl: book.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) => _placeholder(isDark),
                        errorWidget: (_, __, ___) => _errorPlaceholder(isDark),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white)
                              .withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          book.isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: book.isFavorite ? AppColors.error : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.ts.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.ts.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingStars(rating: book.rating, size: 12),
                      Text(
                        book.rating.toString(),
                        style: context.ts.bodySmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(bool isDark) => Container(
        color: isDark ? const Color(0xFF252D18) : Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );

  Widget _errorPlaceholder(bool isDark) => Container(
        color: isDark ? const Color(0xFF252D18) : Colors.grey[200],
        child: Center(
          child: Icon(Icons.broken_image_outlined,
              color: isDark ? AppColors.accent : Colors.grey[400], size: 40),
        ),
      );
}
