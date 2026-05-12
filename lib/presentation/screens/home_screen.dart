import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/zoom_drawer_wrapper.dart';
import '../../generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_text_styles.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_loading.dart';
import 'book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<HomeViewModel>().fetchBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(l10n),
            _buildSearchBar(l10n),
            _buildCategories(),
            Expanded(
              child: Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) return const ShimmerLoading();
                  if (viewModel.books.isEmpty) return _buildEmptyState(l10n);
                  return RefreshIndicator(
                    color: theme.colorScheme.primary,
                    onRefresh: () => viewModel.fetchBooks(),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: viewModel.books.length,
                      itemBuilder: (context, index) {
                        final book = viewModel.books[index];
                        return BookCard(
                          book: book,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailsScreen(book: book),
                            ),
                          ),
                          onFavoriteTap: () => viewModel.toggleFavorite(book.id),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.currentUser?.name.split(' ').first ?? 'Reader';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => ZoomDrawerWrapper.of(context)?.toggle(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(Icons.menu_rounded, color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, $userName!', style: context.ts.bodyMedium),
                  Text(l10n.findNextStory, style: context.ts.h2),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurfaceVariant),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        onChanged: (value) => context.read<HomeViewModel>().searchBooks(value),
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          hintStyle: context.ts.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          filled: true,
          fillColor: theme.cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final theme = Theme.of(context);
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: viewModel.categories.length,
            itemBuilder: (context, index) {
              final category = viewModel.categories[index];
              final isSelected = viewModel.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) viewModel.selectCategory(category);
                  },
                  backgroundColor: theme.cardColor,
                  selectedColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  showCheckmark: false,
                  elevation: isSelected ? 4 : 1,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(l10n.noBooks, style: context.ts.h3.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text(l10n.noBooksSubtitle, style: context.ts.bodySmall),
        ],
      ),
    );
  }
}
