import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<FavoritesViewModel>().fetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites',
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: Consumer<FavoritesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (viewModel.favoriteBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80,
                      color: AppColors.accent.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('No favorites yet',
                      style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Books you mark as favorite will appear here',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => viewModel.fetchFavorites(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: viewModel.favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = viewModel.favoriteBooks[index];
                return BookCard(
                  book: book,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailsScreen(book: book),
                      ),
                    );
                    if (mounted) viewModel.fetchFavorites();
                  },
                  onFavoriteTap: () => viewModel.removeFavorite(book.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
