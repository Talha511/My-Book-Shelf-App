import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/book.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/download_viewmodel.dart';
import '../widgets/rating_stars.dart';
import 'reader_screen.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookHeader(context),
                  const SizedBox(height: 20),
                  _buildRatingRow(context),
                  const SizedBox(height: 24),
                  _buildStats(context),
                  const SizedBox(height: 32),
                  Text('Description', style: context.ts.h3),
                  const SizedBox(height: 12),
                  Text(
                    widget.book.description,
                    style: context.ts.bodyMedium.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildActionButtons(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () => Share.share(
            'Check out "${widget.book.title}" by ${widget.book.author} on MyBookShelf!\nRating: ${widget.book.rating}/5 ⭐',
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'book-${widget.book.id}',
              child: CachedNetworkImage(
                imageUrl: widget.book.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image_outlined, size: 50, color: AppColors.primary),
                        SizedBox(height: 8),
                        Text('Image not found', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.book.title, style: context.ts.h2),
              const SizedBox(height: 4),
              Text(
                'by ${widget.book.author}',
                style: context.ts.bodyLarge.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Text(
            widget.book.category,
            style: context.ts.bodySmall.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.accent
                  : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    return Row(
      children: [
        RatingStars(rating: widget.book.rating, size: 18),
        const SizedBox(width: 8),
        Text(
          widget.book.rating.toString(),
          style: context.ts.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        Text('/5', style: context.ts.bodySmall),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(color: AppColors.secondary.withValues(alpha: 0.25))
            : null,
        boxShadow: isDark
            ? null
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Rating', widget.book.rating.toString(), Icons.star_rounded, Colors.amber),
          _divider(context),
          _buildStatItem(context, 'Pages', '320', Icons.menu_book_rounded, AppColors.secondary),
          _divider(context),
          _buildStatItem(context, 'Language', 'ENG', Icons.language_rounded, AppColors.primary),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) => Container(
        height: 30,
        width: 1,
        color: Theme.of(context).dividerColor,
      );

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: context.ts.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: context.ts.bodySmall),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReaderScreen(book: widget.book),
                  ),
                );
              },
              icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
              label: const Text('Read Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _iconButton(
            context,
            isDark,
            Icons.file_download_outlined,
            AppColors.primary,
            () => _showDownloadProgress(context),
          ),
          const SizedBox(width: 12),
          Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              final idx = viewModel.books.indexWhere((b) => b.id == widget.book.id);
              final isFav = idx != -1 ? viewModel.books[idx].isFavorite : false;
              return _iconButton(
                context,
                isDark,
                isFav ? Icons.favorite : Icons.favorite_border,
                isFav ? AppColors.error : AppColors.textSecondary,
                () => viewModel.toggleFavorite(widget.book.id),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, bool isDark, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isDark ? Border.all(color: AppColors.secondary.withValues(alpha: 0.3)) : null,
          boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: Icon(icon, color: color),
      ),
    );
  }

  void _showDownloadProgress(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final downloadViewModel = context.read<DownloadViewModel>();
    
    if (downloadViewModel.isDownloaded(widget.book.id)) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Book is already downloaded!')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          double progress = 0.0;
          Future.doWhile(() async {
            await Future.delayed(const Duration(milliseconds: 100));
            progress += 0.05;
            if (context.mounted) setDialogState(() {});
            return progress < 1.0;
          }).then((_) {
            if (dialogContext.mounted) Navigator.pop(dialogContext);
          });

          return AlertDialog(
            title: const Text('Downloading Book...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress, color: AppColors.primary),
                const SizedBox(height: 12),
                Text('${(progress * 100).toInt()}%'),
              ],
            ),
          );
        },
      ),
    ).then((_) {
      if (!mounted) return;
      downloadViewModel.downloadBook(widget.book);
      messenger.showSnackBar(
        const SnackBar(content: Text('Download Complete! Book is now available offline.')),
      );
    });
  }
}
