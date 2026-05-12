import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/zoom_drawer_wrapper.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'reading_history_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
    const ReadingHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ZoomDrawerWrapper(
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: _buildBottomBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.uploadBook),
          backgroundColor: theme.colorScheme.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 65,
      color: theme.cardColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home_rounded,
              color: _currentIndex == 0 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: () => setState(() => _currentIndex = 0),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite_rounded,
              color: _currentIndex == 1 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: () => setState(() => _currentIndex = 1),
          ),
          const SizedBox(width: 40), // Space for FAB
          IconButton(
            icon: Icon(
              Icons.person_rounded,
              color: _currentIndex == 2 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: () => setState(() => _currentIndex = 2),
          ),
          IconButton(
            icon: Icon(
              Icons.history_rounded,
              color: _currentIndex == 3 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: () => setState(() => _currentIndex = 3),
          ),
        ],
      ),
    );
  }
}
