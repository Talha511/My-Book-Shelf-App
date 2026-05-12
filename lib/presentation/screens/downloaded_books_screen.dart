import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../viewmodels/download_viewmodel.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class DownloadedBooksScreen extends StatefulWidget {
  const DownloadedBooksScreen({super.key});

  @override
  State<DownloadedBooksScreen> createState() => _DownloadedBooksScreenState();
}

class _DownloadedBooksScreenState extends State<DownloadedBooksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DownloadViewModel>().fetchDownloadedBooks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads', style: context.ts.h3.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: Consumer<DownloadViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (viewModel.downloadedBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_for_offline_outlined, 
                      size: 80, 
                      color: AppColors.accent.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('No downloads yet', 
                      style: context.ts.h3.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Books you download for offline reading will appear here', 
                      style: context.ts.bodySmall),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Explore Books', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: viewModel.downloadedBooks.length,
            itemBuilder: (context, index) {
              final book = viewModel.downloadedBooks[index];
              return Stack(
                children: [
                  BookCard(
                    book: book,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailsScreen(book: book),
                      ),
                    ),
                    onFavoriteTap: () {},
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _confirmDelete(context, viewModel, book),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, DownloadViewModel viewModel, dynamic book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Download?'),
        content: Text('Do you want to remove "${book.title}" from your offline library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.removeDownloadedBook(book.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book removed from downloads')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
